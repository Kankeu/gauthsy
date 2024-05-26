<?php

namespace App\GraphQL\Mutations\Notification;

use App\GraphQL\Exceptions\GraphQLException;
use App\GraphQL\Repositories\NotificationRepository;
use Illuminate\Notifications\DatabaseNotification;


class DeleteNotification
{

    /**
     * @param  null  $_
     * @param  array<string, mixed>  $args
     */
    public function __invoke($_, array $args)
    {
        $data = collect($args['data']);
        $notification = auth()->user()->notifications()->find($data->get('id'));
        if (is_null($notification))
            throw new GraphQLException("Resource not found", ["Notification " . (new DatabaseNotification)->encodeId($data->get('id')) . " not found"], 'resource:8');

        return (new NotificationRepository())->delete($notification);
    }
}
