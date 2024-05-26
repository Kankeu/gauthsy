<?php

namespace App\GraphQL\Validations;

use App\GraphQL\Traits\Validatable;
use App\Models\Document;
use Illuminate\Support\Collection;


trait DocumentValidatable
{
    use Validatable;

    public function creatingRules(Collection $data): Collection
    {
        $data = $this->validateCollection($data, [
            'type' => 'required|filled|string|in:id,ar|same:payload.document_type',
            'number' => 'required|filled|string|max:30|same:payload.document_number',
            'issued_by' => 'required|filled|in:cm,de,rw',
            'images.*.type' => 'required|filled|in:front,back,front_face,face|distinct',
            'images.*.file' => 'required|filled|image|max:2048',
            'images' => 'size:4',
            'payload.surname' => 'required|string|filled|max:30',
            'payload.forename' => 'required|string|filled|max:30',
            'payload.country_code' => 'required|string|filled|in:cmr,d,rwa',
            'payload.document_type' => 'required|string|filled|in:id,ar|max:10',
            'payload.document_number' => 'required|string|filled|max:30',
            'payload.sex' => 'required|filled|in:m,f',
            'payload.birth_date' => 'required|filled|date',
            'payload.expiry_date' => 'required|filled|date|after:' . (now()->toIso8601String()),
            'payload.personal_number' => 'string|filled|max:30',
            'payload.personal_number2' => 'string|filled|max:30',
            'payload.nationality_country_code' => 'required_if:type,ar|string|filled|in:cmr,rwa,deu'
        ]);
        $payload = $data->get('payload');
        $payload['birth_date'] = $payload['birth_date']->format("Y-m-d");
        $payload['expiry_date'] = $payload['expiry_date']->format("Y-m-d");
        $data->put('payload', $payload);
        return $data;
    }

    public function updatingRules(Document $document, Collection $data): Collection
    {
        $rules = [];
        if (is_null($document->nationality_country_code) && $data->get('type') == 'ar')
            $rules['nationality_country_code'] = 'required|string|filled|in:cmr,rwa,deu';

        $data = $this->validateCollection($data, array_merge([
            'type' => 'filled|string|in:id,ar|same:payload.document_type',
            'number' => 'filled|string|max:30|same:payload.document_number',
            'issued_by' => 'filled|in:cm,de,rw',
            'images.*.type' => 'filled|in:front,back,front_face,face|distinct|size:4',
            'images.*.file' => 'filled|image|max:2048',
            'images' => 'size:4',
            'payload.surname' => 'required_with:payload|string|filled|max:30',
            'payload.forename' => 'required_with:payload|string|filled|max:30',
            'payload.country_code' => 'required_with:payload|string|filled|in:cmr,d,rwa',
            'payload.document_type' => 'required_with:payload|in:id,ar|string|filled|max:10',
            'payload.document_number' => 'required_with:payload|string|filled|max:30',
            'payload.sex' => 'required_with:payload|filled|in:m,f',
            'payload.birth_date' => 'required_with:payload|filled|date',
            'payload.expiry_date' => 'required_with:payload|filled|date|after:' . (now()->toIso8601String()),
            'payload.personal_number' => 'required_with:payload|string|filled|max:30',
            'payload.personal_number2' => 'required_with:payload|string|filled|max:30',
        ], $rules));

        if ($data->has('payload')) {
            $payload = $data->get('payload');
            $payload['birth_date'] = $payload['birth_date']->format("Y-m-d");
            $payload['expiry_date'] = $payload['expiry_date']->format("Y-m-d");
            $data->put('payload', $payload);
        }
        return $data;
    }

    public function rejectingRules(Document $document, Collection $data): Collection
    {
        return $this->validateCollection($data, [
            'reason' => 'required|filled|string|max:320'
        ]);
    }
}
