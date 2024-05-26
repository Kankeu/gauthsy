<?php

namespace App\Observers;

use App\Models\Document;

class DocumentObserver
{

    /**
     * Handle the user "deleted" event.
     *
     * @param \App\Models\Document $document
     * @return void
     */
    public function deleted(Document $document)
    {
        if (!$document->isForceDeleting()) {
            $document->images->each(function ($image) {
                $image->delete();
            });
        }
    }

    /**
     * Handle the user "force deleted" event.
     *
     * @param \App\Models\Document $document
     * @return void
     */
    public function forceDeleted(Document $document)
    {
        $document->images()->onlyTrashed()->get()->each(function ($image) {
            $image->forceDelete();
        });
    }
}
