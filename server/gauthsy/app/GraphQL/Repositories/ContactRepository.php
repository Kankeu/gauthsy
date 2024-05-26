<?php

namespace App\GraphQL\Repositories;

use App\GraphQL\Traits\Uploadable;
use App\GraphQL\Validations\ContactValidatable;
use App\Notifications\ContactCreated;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Notification;

class ContactRepository
{

    use ContactValidatable, Uploadable;

    public function create(Collection $data): bool
    {
        $data = $this->creatingRules($data);
        Notification::route('mail', config('company.email'))
            ->notify(new ContactCreated($data->get('full_name'), $data->get('email'), $data->get('message')));
        return true;
    }
}
