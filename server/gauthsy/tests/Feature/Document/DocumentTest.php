<?php

namespace Tests\Feature\Document;

use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Arr;
use Nuwave\Lighthouse\Testing\MakesGraphQLRequests;
use Tests\CreatesApplication;
use Tests\TestCase;

class DocumentTest extends TestCase
{
    use CreatesApplication;
    use MakesGraphQLRequests;

    public function testCreateFailed(): void
    {
        $response = $this->authMultipartGraphQL([
            'query' => /** @lang GraphQL */ '
        mutation ($data: CreateDocumentInput!) {
            createDocument(data: $data) {
                id
            }
        }
    ',
            'variables' => [
                'data' => [
                    'type' => 'AR',
                    'number' => '01',
                    'issued_by' => 'CM',
                    'payload' => [
                        'surname' => '4',
                        'forename' => '4',
                        'country_code' => 'CMR',
                        'document_type' => 'ID',
                        'document_number' => '1',
                        'sex' => 'M',
                        'birth_date' => '2015-10-10',
                        'expiry_date' => '2015-10-11'
                    ],
                    'images' => [
                        [
                            'type' => 'FRONT',
                            'file' => null
                        ]
                    ]
                ]
            ]
        ], [
            "0" => ["variables.data.images.0.file"]
        ], [
            '0' => UploadedFile::fake()->create('image.jpg', 1024),
        ]);
        $response->dump();
        $errors = Arr::get($response->json(), 'errors.0.extensions.errors');

        $this->assertEquals('validation', Arr::get($response->json(), 'errors.0.extensions.category'));
        $this->assertEquals(5, collect($errors)->count());
        $this->assertArrayHasKey('type', $errors);
        $this->assertArrayHasKey('number', $errors);
        $this->assertArrayHasKey('payload.expiry_date', $errors);
        $this->assertArrayHasKey('images', $errors);
        $this->assertArrayHasKey('payload.nationality_country_code', $errors);
    }

    public function testCreate(): void
    {
        $response = $this->authMultipartGraphQL([
            'query' => /** @lang GraphQL */ '
        mutation ($data: CreateDocumentInput!) {
            createDocument(data: $data) {
                id
                type
                number
                issued_by
                images{data{type}}
            }
        }
    ',
            'variables' => [
                'data' => [
                    'type' => 'ID',
                    'number' => '0123456789',
                    'issued_by' => 'CM',
                    'payload' => [
                        'surname' => 'John',
                        'forename' => 'Doe',
                        'country_code' => 'CMR',
                        'document_type' => 'ID',
                        'document_number' => '0123456789',
                        'sex' => 'M',
                        'birth_date' => '1999-10-10',
                        'expiry_date' => '2022-10-11'
                    ],
                    'images' => [
                        [
                            'type' => 'FRONT',
                            'file' => null
                        ],
                        [
                            'type' => 'FRONT_FACE',
                            'file' => null
                        ],
                        [
                            'type' => 'BACK',
                            'file' => null
                        ],
                        [
                            'type' => 'FACE',
                            'file' => null
                        ]
                    ]
                ]
            ]
        ], [
            "0" => ["variables.data.images.0.file"],
            "1" => ["variables.data.images.1.file"],
            "2" => ["variables.data.images.2.file"],
            "3" => ["variables.data.images.3.file"],
        ], [
            '0' => UploadedFile::fake()->create('front.png', 1024),
            '1' => UploadedFile::fake()->create('front_face.png', 1024),
            '2' => UploadedFile::fake()->create('back.png', 1024),
            '3' => UploadedFile::fake()->create('face.png', 1024),
        ]);

        $document = Arr::get($response->json(), 'data.createDocument');

        $this->assertArrayHasKey('id', $document);
        $this->assertArrayHasKey('type', $document);
        $this->assertArrayHasKey('number', $document);
        $this->assertArrayHasKey('issued_by', $document);
        $this->assertArrayHasKey('images', $document);
    }

    public function testValidate(): void
    {
        $user = User::where('email', 'john@gmail.com')->first();
        $response = $this->authGraphQL(/** @lang GraphQL */ '
        mutation ($data: ValidateDocumentInput!) {
            validateDocument(data: $data)
        }
    ', [
            'data' => [
                'id' => $user->documents()->first()->encodedId
            ]
        ]);
        $response->dump();
        $document = $user->documents()->first();
        $this->assertTrue($response->json()['data']['validateDocument']);
        $this->assertTrue($document->valid);
        $this->assertNotNull($document->verified_at);
    }

    public function testReject(): void
    {
        $user = User::where('email', 'john@gmail.com')->first();
        $response = $this->authGraphQL(/** @lang GraphQL */ '
        mutation ($data: RejectDocumentInput!) {
            rejectDocument(data: $data)
        }
    ', [
            'data' => [
                'id' => $user->documents()->first()->encodedId,
                'reason' => $this->faker->text(380)
            ]
        ]);
        $response->dump();
        $document = $user->documents()->first();
        $this->assertTrue($response->json()['data']['rejectDocument']);
        $this->assertFalse($document->valid);
        $this->assertNotNull($document->verified_at);
    }

    public function testGenerateTokenToDocuments(): void
    {
        $user = User::where('email', 'john@gmail.com')->first();
        $response = $this->authGraphQL(/** @lang GraphQL */ '
        mutation ($data: [GenerateTokenToDocumentInput!]!) {
            generateTokenToDocuments(data: $data)
        }
    ', [
            'data' => $user->documents()->get()->map(function ($d) {
                return ['id' => $d->encodedId];
            })
        ]);
        $response->dump();
        $this->assertIsString($response->json()['data']['generateTokenToDocuments']);
    }


    public function testGetImage(): void
    {
        $user = User::where('email', 'john@gmail.com')->first();
        $response = $this->get($user->documents[1]->images[3]->full_path . '?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MTYwOTU4ODUsImlzcyI6Imh0dHA6XC9cL2xvY2FsaG9zdCIsImV4cCI6MTYxNjA5Njc4NSwiYXVkIjoiaHR0cDpcL1wvbG9jYWxob3N0IiwidWlkIjoiZFhObGNuTTZOdz09IiwianRpIjoiZFhObGNuTTZOdz09IiwiY28iOiJHQXV0aFN5IiwiZG9jdW1lbnRzIjpbIlpHOWpkVzFsYm5Sek9qTT0iLCJaRzlqZFcxbGJuUnpPalE9Il19.fmzsPrTgybIDr2fRQ-_KBUY2YL9JPwcPhpOAJCpWPPY');
        $response->assertStatus(200);
    }

    public function testDelete(): void
    {
        $user = User::where('email', 'john@gmail.com')->first();
        $count = $user->documents()->count();
        $response = $this->authGraphQL(/** @lang GraphQL */ '
        mutation ($data: DeleteDocumentInput!) {
            deleteDocument(data: $data)
        }
    ', [
            'data' => [
                'id' => $user->documents()->first()->encodedId
            ]
        ]);
        $response->dump();
        $this->assertTrue($response->json()['data']['deleteDocument']);
        $this->assertEquals($count - 1, $user->documents()->count());
    }
}
