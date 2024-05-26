<?php

namespace App\GraphQL\Queries\AppVersion;

use Carbon\Carbon;

class AppVersion
{
    /**
     * @param  null  $_
     * @param  array<string, mixed>  $args
     */
    public function __invoke($_, array $args)
    {
        return [
            "version" => "1.0.0",
            "must_upgrade" => false,
            "published_at" => Carbon::parse("2021-03-29"),
            "message" => "First version",
        ];
    }
}
