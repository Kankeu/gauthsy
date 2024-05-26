<?php

namespace App\GraphQL\Traits;

use App\Models\Image;
//use App\Jobs\ResizeImage;
use Illuminate\Http\UploadedFile;


trait Uploadable
{
    private function uploadImage(UploadedFile $file, string $path, ?array $sizes, callable $callable, ?Image $image = null): Bool
    {
        $extension = $file->getClientOriginalExtension();
        $name = microtime(true) . '.' . $extension;
        $global_path = $path . $name;
        // move the file
        if ($path = $file->move(storage_path("app/public".$path), $name)) {
            if (is_null($image)) $image = new Image(['path' => $global_path]);
            else $image->fill(['path' => $global_path, 'resized' => false]);
            // save the new path
            $image = $callable($image);
           /*// program a task to resize the image
            if(!is_null($image)&&!is_null($sizes)&&!empty($sizes))
            dispatch(new ResizeImage($image->id, $sizes));*/
            return true;
        }
        return false;
    }

}
