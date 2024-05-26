<?php

namespace App\GraphQL\Mutations\Auth;

class RefreshToken
{
    use BaseAuthResolver;

    /**
     * @param  null  $_
     * @param  array<string, mixed>  $args
     */
    public function __invoke($_, array $args)
    {
        $credentials = $this->buildCredentials($args, 'refresh_token');
        return $this->makeRequest($credentials);
    }
}
