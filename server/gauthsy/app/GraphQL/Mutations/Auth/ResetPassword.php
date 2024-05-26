<?php

namespace App\GraphQL\Mutations\Auth;

use App\GraphQL\Repositories\UserRepository;

class ResetPassword
{
    /**
     * @param  null  $_
     * @param  array<string, mixed>  $args
     */
    public function __invoke($_, array $args)
    {
        return (new UserRepository)->resetPassword(collect($args['data']));
    }
}
