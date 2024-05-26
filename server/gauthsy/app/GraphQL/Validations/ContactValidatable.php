<?php

namespace App\GraphQL\Validations;

use App\GraphQL\Traits\Validatable;
use Illuminate\Support\Collection;


trait ContactValidatable
{
    use Validatable;

    public function creatingRules(Collection $data): Collection
    {
        $data = $this->validateCollection($data, [
            'full_name' => 'required|filled|string|max:30',
            'email' => 'required|filled|email',
            'message' => 'required|filled|string|max:640',
        ]);
        return $data;
    }

}
