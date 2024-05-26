<?php

namespace App\GraphQL\Mutations\Auth;

use App\GraphQL\Repositories\UserRepository;

class Login
{
    use BaseAuthResolver;

    /**
     * @param  null  $_
     * @param  array<string, mixed>  $args
     */
    public function __invoke($_, array $args)
    {
        $data = collect($args['data']);
        $user = (new UserRepository)->login($data);

        $res = collect();
        if($user->hasVerifiedEmail()){
            $data->put('username', $data->get('email'));
            $data->forget('email');
            $credentials = $this->buildCredentials($data, "password");
            $res = $res->merge($this->makeRequest($credentials->toArray()));
         /*   if(auth()->check())
                auth()->logout();
            auth()->login($user);*/
        }
        $res->put('me', $user);

        return $res;
    }

}
