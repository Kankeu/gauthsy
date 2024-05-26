<?php

namespace App\GraphQL\Repositories;

use App\GraphQL\Exceptions\GraphQLException;
use App\GraphQL\Traits\Uploadable;
use App\GraphQL\Validations\DocumentValidatable;
use App\Models\Document;
use App\Models\User;
use App\Notifications\DocumentRejected;
use App\Notifications\DocumentValidated;
use DateTimeImmutable;
use Illuminate\Notifications\DatabaseNotification;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Lcobucci\JWT\Builder;
use Lcobucci\JWT\Parser;
use Lcobucci\JWT\Signer\Hmac\Sha256;
use Lcobucci\JWT\Signer\Key;
use Lcobucci\JWT\Token;

class DocumentRepository
{

    use DocumentValidatable, Uploadable;

    public function create(Collection $data): Document
    {

        $data = $this->creatingRules($data);
        $document = null;
        DB::transaction(function () use (&$document, $data) {
            $document = auth()->user()->documents()->create($data->only("type", "number", "issued_by", "payload")->toArray());

            foreach ($data->get('images') as $imageData) {
                $this->uploadImage(
                    $imageData['file'],
                    '/images/users/' . auth()->id() . '/documents/' . $document->id . '/', null,
                    function ($image) use ($document, $imageData) {
                        $image->type = $imageData['type'];
                        $document->images()->save($image);
                        return $image;
                    });
            }
        }, 3);

        return $document;
    }

    public function update(Document $document, Collection $data): Document
    {
        $data = $this->updatingRules($document, $data);
        DB::transaction(function () use (&$document, $data) {
            if ($data->only("type", "number", "issued_by", "payload")->isNotEmpty())
                $document = auth()->user()->documents()->create($data->only("type", "number", "issued_by", "payload")->toArray());

            if ($data->has('images'))
                foreach ($data->get('images') as $imageData) {
                    $this->uploadImage(
                        $imageData['file'],
                        '/images/users/' . auth()->id() . '/documents/' . $document->id . '/', null,
                        function ($image) use ($document, $imageData) {
                            $image->type = $imageData['type'];
                            $document->images()->save($image);
                            return $image;
                        });
                }
        }, 3);

        return $document;
    }

    public function reject(Document $document, Collection $data): bool
    {
        if ($document->verified_at != null)
            throw new GraphQLException("Can't reject the document", ["Document " . $document->encodedId . " has been already verified"], 'constraint:2');

        $data = $this->rejectingRules($document, $data);
        DB::transaction(function () use (&$document, $data) {
            $document->update(['valid' => false, 'verified_at' => now(), 'message' => $data->get('reason')]);
            $document->owner->notify(new DocumentRejected($document, $data->get('reason')));
        }, 3);
        return true;
    }

    public function validate(Document $document): bool
    {
        if ($document->verified_at != null)
            throw new GraphQLException("Can't validate the document", ["Document " . $document->encodedId . " has been already verified"], 'constraint:3');

        DB::transaction(function () use ($document) {
            $document->update(['valid' => true, 'verified_at' => now()]);
            $document->owner->notify(new DocumentValidated($document));
        }, 3);
        return true;
    }

    public function delete(Document $document): bool
    {
        return $document->delete() != null;
    }

    public function generateToken(string $host, Collection $documents): string
    {
        $time = new DateTimeImmutable();
        return (string)(new Builder())
            ->issuedAt($time)
            ->issuedBy(config('app.url'))
            //->expiresAt($time->modify('+15 minutes')) // expires in 15 minutes
            ->permittedFor(config('app.url'))
            ->withClaim('uid', auth()->user()->encodedId)
            ->identifiedBy(auth()->user()->encodedId)
            ->withClaim('co', config('company.name'))
            ->withClaim('host', $host)
            ->withClaim('documents', $documents->map(function ($document) {
                return $document->encodedId;
            })->toArray())
            ->getToken(new Sha256(), new Key(auth()->user()->secret));
    }

    public function getImage(?string $token, int $userId, int $documentId, string $filename)
    {
        $document = Document::find($documentId);

        if (is_null($document))
            throw new GraphQLException("Resource not found", ["Document " . (new Document)->encodeId($documentId) . " not found"], 'resource:1');

        if ($token != null) {
            $token = $this->parseToken($token, $document->owner);

            if (!collect($token->claims()->get('documents'))->contains($document->encodedId))
                throw new GraphQLException("Unauthorized", ["This token doesn't give you access to the document " . $document->encodedId], 'document:4');
        } else if (!auth()->guard('api')->check() || auth()->guard('api')->user()->id != $userId) {
            throw new GraphQLException("Unauthorized", ["You need to sign in or provide a valid token in header"], 'document:4');
        }
        return \Intervention\Image\Facades\Image::make(storage_path("app/public/images/users/$userId/documents/$documentId/$filename"))->response();
    }

    public function getDocumentIds(string $token): array
    {
        return collect($this->parseToken($token, null)->claims()->get('documents'))->map(function ($e) {
            return (new Document())->decodeId($e);
        })->toArray();
    }

    private function parseToken(string $token, ?User $user): Token
    {
        try {
            $token = (new Parser())->parse($token);
        } catch (\Exception $e) {
            throw new GraphQLException("Invalid token", [], 'document:1');
        }
        if ($user == null)
            $user = User::findByEId($token->claims()->get('uid'));
        if (!$token->verify(new Sha256(), new Key($user->secret)))
            throw new GraphQLException("Invalid token", [], 'document:2');
        //if ($token->isExpired(new DateTimeImmutable()))
        //    throw new GraphQLException("Token has expired", [], 'document:3');
        if ($token->claims()->get('uid') != $user->encodedId)
            throw new GraphQLException("Unauthorized", ["You need to sign in or provide a valid token in header"], 'document:4');
        if($token->claims()->get('host')!=request()->getSchemeAndHttpHost())
            throw new GraphQLException("Invalid host", ["You need to call the API with host ".$token->claims()->get('host')], 'document:6');
        return $token;
    }
}
