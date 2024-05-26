<?php

namespace App\GraphQL\Mutations\Contact;
use App\GraphQL\Repositories\ContactRepository;

class CreateContact
{

    /**
     * @param  null  $_
     * @param  array<string, mixed>  $args
     */
    public function __invoke($_, array $args)
    {
        $data = collect($args['data']);

        return (new ContactRepository())->create($data);
    }
}
