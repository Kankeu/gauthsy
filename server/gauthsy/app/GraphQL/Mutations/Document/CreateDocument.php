<?php

namespace App\GraphQL\Mutations\Document;

use App\GraphQL\Repositories\DocumentRepository;

class CreateDocument
{
    /**
     * @param  null  $_
     * @param  array<string, mixed>  $args
     */
    public function __invoke($_, array $args)
    {
        return (new DocumentRepository())->create(collect($args['data']));
    }
}
