<?php

namespace App\Models;

use App\GraphQL\Traits\GraphQLSerializable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\File;

class Image extends Model
{
    use HasFactory, SoftDeletes, GraphQLSerializable;

    protected $fillable = [
        'type','path', 'resized'
    ];

    protected $attributes = [
        'resized' => false
    ];

    protected $casts = [
        'resized' => 'bool',
    ];

    public function getFileAttribute(): string
    {
    }

    public function getFullPathAttribute(): string
    {
        return url($this->path);
    }
}
