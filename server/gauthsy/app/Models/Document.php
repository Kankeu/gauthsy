<?php

namespace App\Models;

use App\GraphQL\Exceptions\GraphQLException;
use App\GraphQL\Repositories\DocumentRepository;
use App\GraphQL\Traits\GraphQLSerializable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\MorphMany;
use Illuminate\Database\Eloquent\Relations\MorphTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class Document extends Model
{
    use HasFactory, SoftDeletes, GraphQLSerializable;

    protected $fillable = [
        'type', 'number', 'issued_by', 'payload', 'valid', 'verified_at', 'message'
    ];

    protected $attributes = [
        'valid' => false
    ];

    protected $casts = [
        'valid' => 'bool',
        'payload' => 'array',
        'verified_at' => 'datetime',
    ];

    public function owner(): MorphTo
    {
        return $this->morphTo("owner", "ownable_type", "ownable_id");
    }

    public function images(): MorphMany
    {
        return $this->morphMany(Image::class, 'imageable', 'imageable_type', 'imageable_id');
    }

    public function scopeByToken($builder, $args)
    {
        return $builder;
        if (array_key_exists("data", $args))
            return $builder->whereIn('id', (new DocumentRepository())->getDocumentIds($args['data']['token']));
        if (auth()->check() && auth()->user()->isAdmin)
            return $builder;
        throw new GraphQLException("Unauthorized", ["You can access to the documents"], 'document:5');
    }
}
