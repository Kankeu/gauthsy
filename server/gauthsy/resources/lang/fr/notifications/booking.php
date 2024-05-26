<?php

return [
    "created" => [
        "subject" => "Nouvelle réservation",
        "greeting" => "Salut :Forename,",
        "body" => "Vous avez reçu une nouvelle réservation de la part de :Forename pour \":trip\".",
        "message" => "Les détails de la réservation:",
        "passengers_count"=> "     Passagers:",
        "adults_count"=>"        -> Adultes: :adults_count",
        "toddlers_count"=>"        -> Tout-petits: :toddlers_count",
        "action" => "Voir la réservation",
        "footer" => "Merci d'utiliser notre application!",
    ],
    "updated" => [
        "subject" => "Réservation modifiée",
        "greeting" => "Salut :Forename,",
        "body" => ":Forename a modifié sa réservation pour \":trip\".",
        "message" => "Les details de la nouvelle réservation:",
        "passengers_count"=> "     Passagers:",
        "adults_count"=>"        -> Adultes: :adults_count",
        "toddlers_count"=>"        -> Tout-petits: :toddlers_count",
        "action" => "Voir la réservation",
        "footer" => "Merci d'utiliser notre application!",
    ],
    "confirmed" => [
        "subject" => "Réservation confirmée",
        "greeting" => "Salut :Forename,",
        "body" => ":Forename a confirmé votre réservation pour \":trip\".",
        "action" => "Voir la réservation",
        "footer" => "Merci d'utiliser notre application!",
    ],
    "canceled" => [
        "subject" => "Réservation annulée",
        "greeting" => "Salut :Forename,",
        "body" => ":Forename a annulé sa réservation pour \":trip\".",
        "action" => "Voir le voyage",
        "footer" => "Merci d'utiliser notre application!",
    ],
    "rejected" => [
        "subject" => "Réservation rejetée",
        "greeting" => "Salut :Forename,",
        "body" => ":Forename a rejetée votre réservation pour \":trip\".",
        "action" => "Voir le voyage",
        "footer" => "Merci d'utiliser notre application!",
    ],
];
