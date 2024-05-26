<?php

namespace App\GraphQL\Validations;

use App\GraphQL\Traits\Validatable;
use App\Models\User;
use Illuminate\Support\Collection;
use Illuminate\Validation\Rule;


trait UserValidatable
{
    use Validatable;

    public function creatingRules(Collection $data): Collection
    {
        $data = $this->validateCollection($data, [
            'surname' => 'required|filled|string|max:30',
            'forename' => 'required|filled|string|max:30',
            'email' => 'required|filled|email|unique:users',
            'password' => 'required|filled|string|min:6|max:30',
            'locale' => 'filled|in:en'
        ]);
        if (!$data->has('locale'))
            $data->put('locale', 'en');
        return $data;
    }

    public function updatingRules(User $user, Collection $data): Collection
    {
        return $this->validateCollection($data, [
            'surname' => 'filled|string|max:30',
            'forename' => 'filled|string|max:30',
            'password' => 'filled|string|min:6|max:30|required_with:last_password',
            'last_password' => 'filled|string|min:6|max:30|required_with:password',
            'fcm_token'=> 'nullable|filled|string',
            'locale' => 'filled|in:en',
            'email' => ['filled', 'email', Rule::unique('users')->ignore($user->id)],
        ]);
    }


    public function forgotPasswordRules(Collection $data): Collection
    {
        return $this->validateCollection($data, [
            'email' => 'required|filled|email|exists:users',
        ]);
    }

    public function resetPasswordRules(Collection $data): Collection
    {
        return $this->validateCollection($data, [
            'token' => 'required|filled|string',
            'password' => 'required|filled|string|min:6|max:30',
        ]);
    }

}
