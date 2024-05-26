<?php
return [
    "subject"=> "Vérification d'email",
    "heading" => "Bienvenue chez " . config('company.name') . "!",
    "body" => "Veuillez confirmer votre compte chez nous en cliquant sur le bouton ci-dessous  ou vous pouvez aussi copier le lien et coller le dans l'application.",
    "confirm" => "Confirmer mon compte",
    "closing" => "Cordialement,",
    "signature" => "L'équipe " . config('company.name'),
    "mistake" => "Si vous pensez avoir reçu cet e-mail par erreur, veuillez l'ignorer.",
    "advice" => "Ce message n'est valable que 3 jours après la reception.",
    "infos" => [
        "copyright" => "Copyright © " . \Carbon\Carbon::now()->year . ", Tout droit réservé.",
        "email" => "Notre adresse email est:"
    ]
];
