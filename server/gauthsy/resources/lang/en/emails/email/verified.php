<?php
return [
    "subject"=> "Email verification",
    "heading" => "Welcome to " . config('company.name') . "!",
    "body" => "Please confirm your email with us by clicking the button below or you can also copy the link and paste it in the application.",
    "confirm" => "Confirm my email",
    "closing" => "All the best,",
    "signature" => "The " . config('company.name') . " Team",
    "mistake" => "If you believe you received this email by mistake, please ignore this email.",
    "advice" => "This message is valid only 3 days after the reception.",
    "infos" => [
        "copyright" => "Copyright © " . \Carbon\Carbon::now()->year . ", All rights reserved.",
        "email" => "Our mailing address is:"
    ]
];
