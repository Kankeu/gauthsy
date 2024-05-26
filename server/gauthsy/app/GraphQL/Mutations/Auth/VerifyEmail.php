<?php

namespace App\GraphQL\Mutations\Auth;

use App\GraphQL\Repositories\UserRepository;

class VerifyEmail
{
    /**
     * @param  null  $_
     * @param  array<string, mixed>  $args
     */
    public function __invoke($_, array $args)
    {
        return (new UserRepository)->verifyEmail($args['data']['token']);
    }
}
