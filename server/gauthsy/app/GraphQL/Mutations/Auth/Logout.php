<?php

namespace App\GraphQL\Mutations\Auth;

class Logout
{
    use BaseAuthResolver;

    /**
     * @param  null  $_
     * @param  array<string, mixed>  $args
     */
    public function __invoke($_, array $args)
    {
        // revoke user's token
        return auth()->user()->token()->revoke();
    }

}
