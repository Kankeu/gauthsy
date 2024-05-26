<?php

namespace App\Channels;

use Illuminate\Notifications\Notification;

class DatabaseChannel
{

    public function send($notifiable, Notification $notification)
    {
        $data = $notification->toDatabase($notifiable);

        return $notifiable->routeNotificationFor('database')->create([
            'id' => $notification->id,

            'type' => $notification->toDatabaseType(),
            'data' => $data,
            'read_at' => null,
        ]);
    }

}
