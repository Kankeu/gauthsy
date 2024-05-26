<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Support\Facades\File;

class DeleteFolder implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    private $path;

    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct(string $path)
    {
        $this->queue = "folder";
        $this->path = storage_path("app/public".$path);
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        // avoid deleting of app folder
        if (strpos($this->path, '/images/defaults') === false) {
            File::deleteDirectory($this->path);
        }
    }
}
