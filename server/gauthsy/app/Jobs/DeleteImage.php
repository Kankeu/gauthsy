<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Support\Facades\File;

class DeleteImage implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * @var string
     */
    private $file;

    /**
     * Create a new job instance.
     *
     * @param string $file
     * @param bool $transform
     */
    public function __construct(string $file, bool $transform=true)
    {
        $this->queue = "image";
        if($transform){
            // delete the original image and the resized
            $file = explode('.', $file);
            array_pop($file);
            $file = implode('.', $file)."*";
        }
        $this->file = storage_path("app/public".$file);
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        // avoid deleting of app image
        if(strpos($this->file,'/images/defaults')===false){
            $files = File::glob($this->file);
            if(count($files)>0){
                File::delete($files);
            }
        }
    }
}
