<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Support\Facades\Lang;

class ContactCreated extends Notification implements ShouldQueue
{
    use Queueable;

    /**
     * @var string
     */
    private $fullName;

    /**
     * @var string
     */
    private $email;

    /**
     * @var string
     */
    private $message;

    /**
     * Create a new notification instance.
     *
     * @param string $fullName
     * @param string $email
     * @param string $message
     */
    public function __construct(string $fullName, string $email, string $message)
    {
        self::onQueue('emails');
        $this->fullName = $fullName;
        $this->email = $email;
        $this->message = $message;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @param mixed $notifiable
     * @return array
     */
    public function via($notifiable)
    {
        return ['mail'];
    }

    /**
     * Get the mail representation of the notification.
     *
     * @param mixed $notifiable
     * @return \Illuminate\Notifications\Messages\MailMessage
     */
    public function toMail($notifiable)
    {
        return (new MailMessage)->subject(Lang::get('Contact created'))
            ->line(Lang::get("Full name: {$this->fullName}"))
            ->line(Lang::get("Email: {$this->email}"))
            ->line(Lang::get("Message: {$this->message}"));
    }

}
