<?php

namespace App\GraphQL\Mutations\Notification;

use App\GraphQL\Repositories\NotificationRepository;

class MarkAllNotificationsAsRead
{

    /**
     * @param  null  $_
     * @param  array<string, mixed>  $args
     */
    public function __invoke($_, array $args)
    {
        return (new NotificationRepository())->markAllAsRead();
    }
}
