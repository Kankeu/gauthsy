<?php

namespace App\GraphQL\Repositories;

use Illuminate\Notifications\DatabaseNotification;

class NotificationRepository
{

    public function markAllAsRead():bool
    {
        auth()->user()->notifications()->update(['read_at' => now()->toDateTimeString()]);
        return true;
    }

    public function delete(DatabaseNotification $notification): bool
    {
        return $notification->delete() != null;
    }
}
