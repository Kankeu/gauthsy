<?php

namespace App\Observers;

use App\Models\User;

class UserObserver
{

    /**
     * Handle the user "deleted" event.
     *
     * @param \App\Models\User $user
     * @return void
     */
    public function deleted(User $user)
    {
        if (!$user->isForceDeleting()) {
            $user->notifications()->delete();
            $user->documents->each(function ($document) {
                $document->delete();
            });
        }
    }

    /**
     * Handle the user "force deleted" event.
     *
     * @param \App\Models\User $user
     * @return void
     */
    public function forceDeleted(User $user)
    {
        $user->documents()->onlyTrashed()->get()->each(function ($document) {
            $document->forceDelete();
        });
        $user->notifications()->onlyTrashed()->forceDelete();
    }
}
