<?php

namespace App\GraphQL\Mutations\Auth;

class RevokeAllTokens
{
    /**
     * @param  null  $_
     * @param  array<string, mixed>  $args
     */
    public function __invoke($_, array $args)
    {
         foreach(auth()->user()->tokens as $token)
             $token->revoke();
         return true;
    }
}
