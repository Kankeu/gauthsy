<?php

namespace App\Models;

use App\GraphQL\Traits\GraphQLSerializable;
use DateTimeInterface;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Contracts\Translation\HasLocalePreference;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\MorphMany;
use Illuminate\Database\Eloquent\Relations\MorphOne;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Passport\HasApiTokens;

class User extends Authenticatable implements MustVerifyEmail, HasLocalePreference
{
    use HasApiTokens, HasFactory, Notifiable, SoftDeletes, GraphQLSerializable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'forename', 'surname', 'secret', 'email', 'password', 'locale', 'fcm_token', 'email_verified_at', 'role'
    ];


    protected $attributes = [
        'role' => 'user'
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'secret', 'email_verified_at', 'fcm_token'
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    public function getUnreadNotificationsCountAttribute(): int
    {
        return $this->unreadNotifications()->count();
    }

    public function getIsAdminAttribute(): bool
    {
        return $this->role == "admin";
    }

    public function documents(): MorphMany
    {
        return $this->morphMany(Document::class, 'documents', 'ownable_type', 'ownable_id');
    }

    public function preferredLocale()
    {
        return $this->locale;
    }

    /**
     * Specifies the user's FCM token
     *
     * @return string
     */
    public function routeNotificationForFcm()
    {
        return $this->fcm_token;
    }

    public function serializeDate(DateTimeInterface $date)
    {
        return $date->format('c');
    }
}
