<?php

namespace App\Providers;

use App\Models\Document;
use App\Models\Image;
use App\Observers\DocumentObserver;
use App\Observers\ImageObserver;
use App\Observers\UserObserver;
use App\Models\User;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        $this->app->bind(
            \Illuminate\Notifications\Channels\DatabaseChannel::class,
            \App\Channels\DatabaseChannel::class
        );
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        User::observe(UserObserver::class);
        Image::observe(ImageObserver::class);
        Document::observe(DocumentObserver::class);
    }
}
