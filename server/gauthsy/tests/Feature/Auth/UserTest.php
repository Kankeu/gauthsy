<?php

namespace Tests\Feature\Auth;

use App\Models\User;
use Illuminate\Support\Arr;
use Nuwave\Lighthouse\Testing\MakesGraphQLRequests;
use Tests\CreatesApplication;
use Tests\TestCase;

class UserTest extends TestCase
{
    use CreatesApplication;
    use MakesGraphQLRequests;

    public function testSignUpFailed(): void
    {
        $response = $this->graphQL(/** @lang GraphQL */ '
        mutation ($data: SignUpInput!) {
            signUp(data: $data) {
                id
            }
        }
    ', [
            'data' => [
                'surname' => '4',
                'forename' => '4',
                'email' => 'asd',
                'password' => '12345'
            ]
        ]);
        $errors = Arr::get($response->json(), 'errors.0.extensions.errors');

        $this->assertEquals('validation', Arr::get($response->json(), 'errors.0.extensions.category'));
        $this->assertEquals(2, collect($errors)->count());
        $this->assertArrayHasKey('password', $errors);
        $this->assertArrayHasKey('email', $errors);
    }

    public function testSignUp(): void
    {
        $exists = User::where('email', 'john@gmail.com')->exists();
        $response = $this->graphQL(/** @lang GraphQL */ '
        mutation ($data: SignUpInput!) {
            signUp(data: $data) {
                id
                surname
                forename
                email
            }
        }
    ', [
            'data' => [
                'surname' => 'Doe',
                'forename' => 'John',
                'email' => 'john@gmail.com',
                'password' => '000000'
            ]
        ]);
        if ($exists)
            $this->assertArrayHasKey('email', Arr::get($response->json(), 'errors.0.extensions.errors'));
        else {
            $response->assertJson([
                'data' => [
                    'signUp' => [
                        'surname' => 'Doe',
                        'forename' => 'John',
                        'email' => 'john@gmail.com',
                    ]
                ]
            ]);

            $this->assertNotNull($response->json()['data']['signUp']['id']);
        }

    }

    public function testResentEmailVerified(): void
    {
        $user = User::where('email', 'john@gmail.com')->first();
        $response = $this->graphQL(/** @lang GraphQL */ '
        mutation ($data: ResentEmailVerifiedInput!) {
            resentEmailVerified(data: $data)
        }
    ', [
            'data' => [
                'id' => $user->encodedId,
            ]
        ]);
        $response->assertExactJson([
            'data' => ['resentEmailVerified' => true]
        ]);

    }

    public function testVerifyEmail(): void
    {
        $user = User::where('email', 'john@gmail.com')->first();

        $response = $this->graphQL(/** @lang GraphQL */ '
        mutation ($data: VerifyEmailInput!) {
            verifyEmail(data: $data)
        }
    ', [
            'data' => [
                'token' => 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MTU5Mzg3MTAsImlzcyI6Imh0dHA6XC9cL2xvY2FsaG9zdCIsImV4cCI6MTYxNjE5NzkxMCwiYXVkIjoiaHR0cDpcL1wvbG9jYWxob3N0IiwidWlkIjoiZFhObGNuTTZOdz09IiwianRpIjoiZFhObGNuTTZOdz09IiwiY28iOiJHQXV0aFN5IiwiZW1haWwiOiJqb2huQGdtYWlsLmNvbSJ9.K-J0yEl7O5QF7LJEt-aMBkNwAa6Ks4KlVCHY6FiPJtw',
            ]
        ]);

        $response->assertExactJson([
            'data' => ['verifyEmail' => true]
        ]);
    }

    public function testLogin(): void
    {
        $user = User::where('email', 'john@gmail.com')->first();
        $response = $this->graphQL(/** @lang GraphQL */ '
        mutation signUp($data: LoginInput!) {
            login(data: $data) {
              access_token
              refresh_token
              expires_in
              token_type
              me{
                  email
              }
            }
        }
    ', [
            'data' => [
                'email' => 'john@gmail.com',
                'password' => '000000'
            ]
        ]);

        if ($user->hasVerifiedEmail()) {
            $this->assertNotNull(Arr::get($response->json(), 'data.login.access_token'));
            $this->assertNotNull(Arr::get($response->json(), 'data.login.refresh_token'));
            $this->assertNotNull(Arr::get($response->json(), 'data.login.expires_in'));
            $this->assertNotNull(Arr::get($response->json(), 'data.login.token_type'));
        } else {
            $this->assertNull(Arr::get($response->json(), 'data.login.access_token'));
            $this->assertNull(Arr::get($response->json(), 'data.login.refresh_token'));
            $this->assertNull(Arr::get($response->json(), 'data.login.expires_in'));
            $this->assertNull(Arr::get($response->json(), 'data.login.token_type'));
        }

        $this->assertEquals('john@gmail.com', Arr::get($response->json(), 'data.login.me.email'));

    }

    public function testUpdateUser(): void
    {
        $response = $this->authGraphQL(
        /** @lang GraphQL */ 'mutation ($data: UpdateUserInput!) {
                updateUser(data: $data){
                    email
                }
            }',
            [
                "data" => [
                    "email" => 'john@gmail.com',
                    "last_password" => '000000',
                    "password" => '000000',
                ]
            ]
        );
        $response->dump();
        $this->assertEquals('john@gmail.com', Arr::get($response->json(), 'data.updateUser.email'));
    }

}
