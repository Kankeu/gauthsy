<?php

namespace App\GraphQL\Mutations\Auth;

use App\GraphQL\Repositories\UserRepository;

class SignUp
{
    use BaseAuthResolver;

    /**
     * @param  null  $_
     * @param  array<string, mixed>  $args
     */
    public function __invoke($_, array $args)
    {
        $data = collect($args['data']);

        return (new UserRepository())->create($data);
    }

}
