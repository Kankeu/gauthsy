<?php

namespace App\GraphQL\Scalars;

use GraphQL\Error\Error;
use GraphQL\Type\Definition\ScalarType;

/**
 * Read more about scalars here http://webonyx.github.io/graphql-php/type-system/scalar-types/
 */
class JSON extends ScalarType
{
    /**
     * Serializes an internal value to include in a response.
     *
     * @param mixed $value
     * @return mixed
     */
    public function serialize($value)
    {
        return json_decode(json_encode($value,JSON_FORCE_OBJECT));
    }

    /**
     * Parses an externally provided value (query variable) to use as an input
     *
     * @param mixed $value
     * @return mixed
     * @throws Error
     */
    public function parseValue($value)
    {
        return $this->tryParsingJSON($value);
    }

    /**
     * Parses an externally provided literal value (hardcoded in GraphQL query) to use as an input.
     *
     * E.g.
     * {
     *   user(email: "user@example.com")
     * }
     *
     * @param \GraphQL\Language\AST\Node $valueNode
     * @param mixed[]|null $variables
     * @return mixed
     * @throws Error
     */
    public function parseLiteral($valueNode, ?array $variables = null): array
    {
        return $this->tryParsingJSON($valueNode->value);
    }

    /**
     * Try to parse the given value into a Carbon instance, throw if it does not work.
     *
     * @param string $value
     * @return array
     *
     * @throws Error
     */
    protected function tryParsingJSON($value): array
    {
        $res = json_decode($value, true);
        if ($res == null)
            throw new Error("Query error: Can only parse json's string  to array");
        return $res;
    }
}
