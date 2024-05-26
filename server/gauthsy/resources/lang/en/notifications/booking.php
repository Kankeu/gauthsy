<?php

return [
    "created" => [
        "subject" => "New booking",
        "greeting" => "Hello :Forename,",
        "body" => "You have received a new booking from :Forename for the trip \":trip\".",
        "message" => "The details of the booking:",
        "passengers_count" => "     Passengers:",
        "adults_count" => "        -> Adults: :adults_count",
        "toddlers_count" => "        -> Toddlers: :toddlers_count",
        "action" => "See the booking",
        "footer" => "Thank you for using our application!",
    ],
    "updated" => [
        "subject" => "Booking updated",
        "greeting" => "Hello :Forename,",
        "body" => ":Forename has changed his booking for the trip \":trip\".",
        "message" => "The details of the new booking:",
        "passengers_count" => "     Passengers:",
        "adults_count" => "        -> Adults: :adults_count",
        "toddlers_count" => "        -> Toddlers: :toddlers_count",
        "action" => "See the booking",
        "footer" => "Thank you for using our application!",
    ],
    "confirmed" => [
        "subject" => "Booking confirmed",
        "greeting" => "Hello :Forename,",
        "body" => ":Forename has confirmed your booking for the trip \":trip\".",
        "action" => "See the booking",
        "footer" => "Thank you for using our application!",
    ],
    "canceled" => [
        "subject" => "Booking canceled",
        "greeting" => "Hello :Forename,",
        "body" => ":Forename has canceled his booking for the trip \":trip\".",
        "action" => "See the trip",
        "footer" => "Thank you for using our application!",
    ],
    "rejected" => [
        "subject" => "Booking rejected",
        "greeting" => "Hello :Forename,",
        "body" => ":Forename has rejected your booking for the trip \":trip\".",
        "action" => "See the trip",
        "footer" => "Thank you for using our application!",
    ],
];
