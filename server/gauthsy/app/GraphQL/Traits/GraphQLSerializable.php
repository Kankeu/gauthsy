<?php

namespace App\GraphQL\Traits;

use App\GraphQL\Exceptions\GraphQLException;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

trait GraphQLSerializable
{
    public function getEncodedIdAttribute(): string
    {
        return base64_encode($this->getMorphClass() . ":" . $this->id);
    }

    public function encodeId(string $id): string
    {
        return base64_encode($this->getMorphClass() . ":" . $id);
    }

    public function decodeId(string $id): string
    {
        return explode(':', base64_decode($id))[1];
    }

    public function decodeType(string $id): string
    {
        return explode(':', base64_decode($id))[0];
    }

    public function toGraphQLArray(): array
    {
        return collect($this->toArray())->mapWithKeys(function ($v, $k) {
            $tmp = [];
            if ($this->$k instanceof Model) $tmp[$k] = $this->$k->toGraphQLArray();
            else if ($this->{Str::camel($k)} instanceof Model) $tmp[$k] = $this->{Str::camel($k)}->toGraphQLArray();
            else $tmp[$k] = $k == 'id' ? $this->encodedId : $v;
            return $tmp;
        })->toArray();
    }

    // find a model by encoded id
    public static function findByEId(string $id)
    {
        $className = __CLASS__;
        $type = (new $className())->getMorphClass();
        $parts = explode(':', base64_decode($id));
        if ($type != $parts[0])
            throw new GraphQLException("Invalid encoded id", ["The Type of encoded id doesn't correspond to the \"$type\""], "resource:2");
        return self::find($parts[1]);
    }

}
