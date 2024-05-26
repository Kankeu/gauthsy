<?php

namespace App\GraphQL\Directives;

use GraphQL\Type\Definition\ResolveInfo;
use Nuwave\Lighthouse\Schema\Values\FieldValue;
use Nuwave\Lighthouse\Schema\Directives\BaseDirective;
use Nuwave\Lighthouse\Support\Contracts\ArgTransformerDirective;
use Nuwave\Lighthouse\Support\Contracts\FieldMiddleware;
use Nuwave\Lighthouse\Support\Contracts\GraphQLContext;

class JsonDirective extends BaseDirective implements FieldMiddleware, ArgTransformerDirective
{
    /**
     * Name of the directive.
     *
     * @return string
     */
    public function name(): string
    {
        return 'json';
    }

    /**
     * Resolve the field directive.
     *
     * @param \Nuwave\Lighthouse\Schema\Values\FieldValue $fieldValue
     * @param \Closure $next
     * @return \Nuwave\Lighthouse\Schema\Values\FieldValue
     */
    public function handleField(FieldValue $fieldValue, \Closure $next): FieldValue
    {
        $resolver = $fieldValue->getResolver();
        return $next(
            $fieldValue->setResolver(
            /**
             * @param $root
             * @param array $args
             * @param GraphQLContext $context
             * @param ResolveInfo $info
             * @return string
             */ function ($root, array $args, GraphQLContext $context, ResolveInfo $info) use ($resolver): string {
                    $result = $resolver($root, $args, $context, $info);

                    return json_encode($result);
                }
            )
        );
    }


    /**
     * Decodes a global id given as an argument.
     *
     * @param string $argumentValue
     * @return string|string[]
     */
    public function transform($argumentValue)
    {
        return json_decode($argumentValue);
    }

    public static function definition(): string
    {
        return /** @lang GraphQL */ <<<'GRAPHQL'
"""
Converts between string and json.
"""
directive @json on FIELD_DEFINITION | INPUT_FIELD_DEFINITION | ARGUMENT_DEFINITION
GRAPHQL;
    }
}
