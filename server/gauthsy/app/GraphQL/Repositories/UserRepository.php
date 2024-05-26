<?php

namespace App\GraphQL\Repositories;

use App\GraphQL\Exceptions\GraphQLException;
use App\GraphQL\Traits\Uploadable;
use App\GraphQL\Validations\UserValidatable;
use App\Mail\EmailVerified;
use App\Notifications\ResetPassword;
use DateTimeImmutable;
use Illuminate\Support\Collection;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Lcobucci\JWT\Builder;
use Lcobucci\JWT\Parser;
use Lcobucci\JWT\Signer\Hmac\Sha256;
use Lcobucci\JWT\Signer\Key;
use Lcobucci\JWT\Token;

class UserRepository
{

    use UserValidatable, Uploadable;

    public function create(Collection $data): User
    {
        $data = $this->creatingRules($data);
        $user = null;
        DB::transaction(function () use (&$user, $data) {
            $data->put('password', Hash::make($data->get('password')));
            $data->put('secret', Str::random(30));
            $user = User::create($data->toArray());
            $token = $this->generateTokenForEmailVerified($user);
            Mail::to($user)->send(new EmailVerified($user, (string)$token));
        }, 3);
        return $user;
    }

    public function update(User $user, Collection $data): ?User
    {
        $data = $this->updatingRules($user, $data);
        DB::transaction(function () use (&$user, $data) {

            if ($data->has('last_password')) {
                if (!Hash::check($data->get('last_password'), $user->password))
                    throw new GraphQLException("Password change failed", ['last password invalid'], 'auth:5');
                $data->put('password', Hash::make($data->get('password')));
            }
            if ($data->has('email') && $data->get('email') != auth()->user()->email) {
                $token = $this->generateTokenForEmailVerified($user, $data->get('email'));
                Mail::to($data->get('email'))->send(new EmailVerified($user, (string)$token));
                $data->forget('email');
            }
        },3);
        $user->update($data->toArray());

        return $user;
    }


    public function delete(User $user): bool
    {
        return $user->delete() != null;
    }

    private function generateTokenForEmailVerified(User $user, string $email = null): Token
    {
        $time = new DateTimeImmutable();
        return (new Builder())
            ->issuedAt($time)
            ->issuedBy(config('app.url'))
            ->expiresAt($time->modify('+3 days')) // expires in 3 days
            ->permittedFor(config('app.url'))
            ->withClaim('uid', $user->encodedId)
            ->identifiedBy($user->encodedId)
            ->withClaim('co', config('company.name'))
            ->withClaim('email', $email ?? $user->email)
            ->getToken(new Sha256(), new Key(config('company.jwt.key')));
    }

    public function resendEmailVerified(string $id): bool
    {
        $encodedId = (new User)->encodeId($id);
        $user = User::find($id);
        if (is_null($user))
            throw new GraphQLException("Resource not found", ["User \"{$encodedId}\" not found"], 'resource:0');
        if ($user->hasVerifiedEmail())
            throw new GraphQLException("The email address can't be confirmed two times", ["User \"{$user->encodedId}\" is already verified"], 'constraint:1');
        $token = $this->generateTokenForEmailVerified($user);
        Mail::to($user)->queue(new EmailVerified($user, (string)$token));
        return true;
    }

    public function verifyEmail(string $token): bool
    {
        $token = $this->parseToken($token);
        $email = $token->claims()->get('email');
        $id = (new User)->decodeId($token->claims()->get('uid'));
        $user = User::find($id);
        if (is_null($user))
            throw new GraphQLException("User \"{$user->encodedId}\" not found", [], 'resource:0');
        $user->update(['email' => $email, 'email_verified_at' => now()->toDateTimeString()]);
        return true;
    }

    private function parseToken(string $token): Token
    {
        try {
            $token = (new Parser())->parse($token);
        } catch (\Exception $e) {
            throw new GraphQLException("Invalid token", [], 'auth:1');
        }
        if (!$token->verify(new Sha256(), new Key(config('company.jwt.key'))))
            throw new GraphQLException("Invalid token", [], 'auth:2');
        if ($token->isExpired(new DateTimeImmutable()))
            throw new GraphQLException("Token has expired", [], 'auth:3');
        return $token;
    }

    public function login(Collection $data): User
    {
        $user = User::where('email', $data->get('email'))->first();
        if (is_null($user) || !Hash::check($data->get('password'), $user->password))
            throw new GraphQLException("Authentication failed", ['Email or password invalid'], 'auth:4');
        return $user;
    }

    public function forgotPassword(Collection $data): bool
    {
        $data = $this->forgotPasswordRules($data);
        $user = User::where('email', $data->get('email'))->first();
        $user->notify(new ResetPassword((string)$this->generateTokenForPasswordForgot($user)));
        return true;
    }

    public function resetPassword(Collection $data): bool
    {
        $data = $this->resetPasswordRules($data);
        $token = $this->parseToken($data->get('token'));
        $id = (new User)->decodeId($token->claims()->get('uid'));
        $user = User::find($id);
        if (is_null($user))
            throw new GraphQLException("User \"{$user->encodedId}\" not found", [], 'resource:0');
        return $user->update(['password' => Hash::make($data->get('password'))]);
    }


    private function generateTokenForPasswordForgot(User $user, string $email = null): Token
    {
        $time = new DateTimeImmutable();
        return (new Builder())
            ->issuedAt($time)
            ->issuedBy(config('app.url'))
            ->expiresAt($time->modify('+3 days')) // expires in 3 days
            ->permittedFor(config('app.url'))
            ->withClaim('uid', $user->encodedId)
            ->identifiedBy($user->encodedId)
            ->withClaim('co', config('company.name'))
            ->withClaim('email', $email ?? $user->email)
            ->getToken(new Sha256(), new Key(config('company.jwt.key')));
    }


}
