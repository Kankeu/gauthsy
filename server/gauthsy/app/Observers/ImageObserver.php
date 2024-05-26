<?php

namespace App\Observers;

use App\Models\Image;
use App\Jobs\DeleteImage;

class ImageObserver
{
    /**
     * Handle the image "restored" event.
     *
     * @param  \App\Models\Image  $image
     * @return void
     */
    public function updating(Image $image)
    {
        if ($image->isDirty('path'))
            dispatch(new DeleteImage($image->path));
    }

    /**
     * Handle the image "force deleted" event.
     *
     * @param  \App\Models\Image  $image
     * @return void
     */
    public function forceDeleted(Image $image)
    {
        dispatch(new DeleteImage($image->path));
    }

}
