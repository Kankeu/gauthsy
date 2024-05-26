<?php

namespace App\Notifications;

use App\Models\Document;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Support\Facades\Lang;
use NotificationChannels\Fcm\FcmChannel;
use NotificationChannels\Fcm\FcmMessage;

class DocumentValidated extends Notification implements ShouldQueue
{
    use Queueable;

    /**
     * @var Document
     */
    private $document;

    /**
     * Create a new notification instance.
     *
     * @param Document $document
     * @param string $reason
     */
    public function __construct(Document $document)
    {
        self::onQueue('emails');
        $this->document = $document;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @param mixed $notifiable
     * @return array
     */
    public function via($notifiable)
    {
        return ['mail', FcmChannel::class];
    }

    /**
     * Get the mail representation of the notification.
     *
     * @param mixed $notifiable
     * @return \Illuminate\Notifications\Messages\MailMessage
     */
    public function toMail($notifiable)
    {
        $url = url("/api/documents/{$this->document->encodedId}");
        return (new MailMessage)->subject(Lang::get('Document validated'))
            ->line(Lang::get("Your identity document with number \"{$this->document->number}\" has been validated."))
            ->line(Lang::get("You can now use this document online."))
            ->action(Lang::get('See the document'), $url)
            ->success();
    }

    /**
     * Get the mail representation of the notification.
     *
     * @param mixed $notifiable
     * @return FcmMessage
     */
    public function toFcm($notifiable)
    {
        return FcmMessage::create()
            ->setData(['data' => json_encode($this->document->toGraphQLArray()), 'event' => $this->toDatabaseType()]);
    }

    public function toDatabaseType()
    {
        return "document.validated";
    }
}
