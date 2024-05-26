<?php

namespace App\GraphQL\Mutations\Document;

use App\GraphQL\Exceptions\GraphQLException;
use App\GraphQL\Repositories\DocumentRepository;
use App\Models\Document;
use Carbon\Carbon;

class GenerateTokenToDocuments
{
    /**
     * @param  null  $_
     * @param  array<string, mixed>  $args
     */
    public function __invoke($_, array $args)
    {
        return (new DocumentRepository())->generateToken($args['data']['host'],collect($args['data']['documents'])->map(function($e){
            $data = collect($e);
            $document = auth()->user()->documents()->find($data->get('id'));

            if (is_null($document))
                throw new GraphQLException("Resource not found", ["Document ".(new Document)->encodeId($data->get("id"))." not found"], 'resource:1');
            if (Carbon::parse(collect($document->payload)->get('expiry_date'))<now())
                throw new GraphQLException("Invalid document", ["Document ".$document->number." has expired"], 'constraint:4');
            if (!$document->valid)
                throw new GraphQLException("Invalid document", ["Document ".$document->number." should be validated"], 'constraint:5');
            return $document;
        }));
    }
}
