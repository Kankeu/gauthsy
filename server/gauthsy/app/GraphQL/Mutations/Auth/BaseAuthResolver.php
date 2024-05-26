<?php

namespace App\GraphQL\Mutations\Auth;

use Illuminate\Http\Request;
use Illuminate\Support\Collection;
use Nuwave\Lighthouse\Exceptions\AuthenticationException;

trait BaseAuthResolver
{
    /**
     * @param Collection $credentials
     * @param string $grantType
     * @return mixed
     */
    public function buildCredentials(Collection $credentials, $grantType = "password")
    {
        $credentials->put('client_id', config('lighthouse-graphql-passport.client_id'));
        $credentials->put('client_secret', config('lighthouse-graphql-passport.client_secret'));
        $credentials->put('grant_type', $grantType);
        return $credentials;
    }

    /**
     * @param array $credentials
     * @return mixed
     * @throws AuthenticationException
     */
    public function makeRequest(array $credentials)
    {
        $request = Request::create('oauth/token', 'POST', $credentials,[], [], [
            'HTTP_Accept' => 'application/json'
        ]);
        $response = app()->handle($request);
        $decodedResponse = json_decode($response->getContent(), true);
        if ($response->getStatusCode() != 200) {
            throw new AuthenticationException($decodedResponse['message']);
        }
        return $decodedResponse;
    }
}
