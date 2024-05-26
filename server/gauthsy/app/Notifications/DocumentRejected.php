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

class DocumentRejected extends Notification implements ShouldQueue
{
    use Queueable;

    /**
     * @var Document
     */
    private $document;

    /**
     * @var string
     */
    private $reason;

    /**
     * Create a new notification instance.
     *
     * @param Document $document
     * @param string $reason
     */
    public function __construct(Document $document, string $reason)
    {
        self::onQueue('emails');
        $this->reason = $reason;
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
        return (new MailMessage)->subject(Lang::get('Document rejected'))
            ->line(Lang::get("Your identity document with number \"{$this->document->number}\" has been rejected."))
            ->line(Lang::get("Reason: \"{$this->reason}\""))
            ->line(Lang::get("You need to delete and rescan the document better again."))
            ->action(Lang::get('See the document'), $url);
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
        return "document.rejected";
    }
}
