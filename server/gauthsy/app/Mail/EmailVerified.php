<?php

namespace App\Mail;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class EmailVerified extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;


    /**
     * @var User
     */
    private $user;
    private $token;

    /**
     * Create a new message instance.
     *
     * @param User $user
     */

    public function __construct(User $user, string $token)
    {
        self::onQueue('emails');
        $this->user = $user;
        $this->token = $token;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->view('emails.email.verified', [
            'token' => $this->token,
            'forename' => $this->user->forename,
            'confirmationUrl' => url("/api/email/verified/{$this->user->encodedId}/{$this->token}"),
        ])->subject(__('emails/email/verified.subject'));
    }
}
