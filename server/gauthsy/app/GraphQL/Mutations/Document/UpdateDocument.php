<?php

namespace App\GraphQL\Mutations\Document;

use App\GraphQL\Exceptions\GraphQLException;
use App\GraphQL\Repositories\DocumentRepository;
use App\Models\Document;

class UpdateDocument
{
    /**
     * @param  null  $_
     * @param  array<string, mixed>  $args
     */
    public function __invoke($_, array $args)
    {
        $data = collect($args['data']);
        $document = auth()->user()->documents()->find($data->get('id'));

        if (is_null($document))
            throw new GraphQLException("Resource not found", ["Document ".(new Document)->encodeId($data->get("id"))." not found"], 'resource:1');

        return (new DocumentRepository())->update($document, $data);
    }
}
