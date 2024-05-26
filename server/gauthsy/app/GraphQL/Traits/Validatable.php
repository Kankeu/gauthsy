<?php

namespace App\GraphQL\Traits;

use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Support\Collection;
use Illuminate\Validation\ValidationException;
use App\GraphQL\Exceptions\GraphQLException;

trait Validatable{
    use ValidatesRequests;

    public function validateCollection(Collection $data, array $rules): Collection
    {
        try {
            return collect($this->getValidationFactory()->make($data->toArray(), $rules)->validate());
        } catch (ValidationException $e) {
            throw new GraphQLException("The given data was invalid" ,$e->errors(),  "validation");
        }
    }


}
