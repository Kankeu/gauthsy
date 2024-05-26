<?php

namespace Tests;

use Illuminate\Foundation\Testing\WithFaker;
use Nuwave\Lighthouse\Testing\MakesGraphQLRequests;
use Illuminate\Foundation\Testing\TestCase as BaseTestCase;

abstract class TestCase extends BaseTestCase
{
    use CreatesApplication;
    use MakesGraphQLRequests;
    use WithFaker;

    public function authGraphQL(string $query, array $variables = [], array $credentials = null, array $extraParams = [])
    {
        return $this->multipartGraphQL([
            "query" => $query,
            "variables" => $variables
        ], [], [], ['Authorization' => $this->getToken($credentials)]);
    }

    public function authMultipartGraphQL(array $operations, array $map, array $files, array $credentials = null, array $headers = [])
    {
        return $this->multipartGraphQL($operations, $map, $files, ['Authorization' => $this->getToken($credentials)]);
    }

    public function getToken(array $credentials = null)
    {
        if (is_null($credentials)) $credentials = ['email' => 'john@gmail.com', 'password' => '000000'];
        $response = $this->graphQL(/** @lang GraphQL */ '
        mutation signUp($data: LoginInput!) {
            login(data: $data) {
              access_token
              token_type
            }
        }
    ', [
            'data' => $credentials
        ]);
        return $response->json()['data']['login']['token_type'] . " " . $response->json()['data']['login']['access_token'];

    }

}
