<?php

namespace App\GraphQL\Mutations\Auth;

use App\GraphQL\Repositories\UserRepository;

class UpdateUser
{
    /**
     * @param  null  $_
     * @param  array<string, mixed>  $args
     */
    public function __invoke($_, array $args)
    {
        return (new UserRepository())->update(auth()->user(), collect($args['data']));
    }
}
