<?php

namespace App\GraphQL\Directives;

use Illuminate\Database\Eloquent\Model;
use Nuwave\Lighthouse\Exceptions\DefinitionException;
use Nuwave\Lighthouse\Schema\Values\FieldValue;
use Nuwave\Lighthouse\Schema\Directives\BaseDirective;
use Nuwave\Lighthouse\Support\Contracts\ArgDirective;
use Nuwave\Lighthouse\Support\Contracts\ArgSanitizerDirective;
use Nuwave\Lighthouse\Support\Contracts\GlobalId;
use Nuwave\Lighthouse\Support\Contracts\FieldMiddleware;

class GlobalIdDirective extends BaseDirective implements FieldMiddleware,  ArgSanitizerDirective, ArgDirective
{
    /**
     * Name of the directive.
     *
     * @return string
     */
    public function name(): string
    {
        return 'globalId';
    }

    /**
     * The GlobalId resolver.
     *
     * @var \Nuwave\Lighthouse\Support\Contracts\GlobalId
     */
    protected $globalId;

    /**
     * GlobalIdDirective constructor.
     *
     * @param \Nuwave\Lighthouse\Support\Contracts\GlobalId $globalId
     * @return void
     */
    public function __construct(GlobalId $globalId)
    {
        $this->globalId = $globalId;
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
                function (Model $model) use ($resolver) {
                    $resolvedValue = call_user_func_array($resolver, func_get_args());

                    return $this->globalId->encode(
                        $model->getMorphClass(),
                        $resolvedValue
                    );
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
    public function sanitize($argumentValue)
    {
        if(is_numeric($argumentValue)) return (string) $argumentValue;
        if ($decode = $this->directiveArgValue('decode')) {
            switch ($decode) {
                case 'TYPE':
                    return $this->globalId->decodeType($argumentValue);
                case 'ID':
                    return $this->globalId->decodeID($argumentValue);
                case 'ARRAY':
                    return $this->globalId->decode($argumentValue);
                default:
                    throw new DefinitionException(
                        "The only argument of the @globalId directive can only be ID or TYPE, got {$decode}"
                    );
            }
        }
        return $this->globalId->decode($argumentValue);
    }

    public static function definition(): string
    {
        return /** @lang GraphQL */ <<<'GRAPHQL'
"""
Converts between IDs/types and global IDs.
When used upon a field, it encodes,
when used upon an argument, it decodes.
"""
directive @globalId(
  """
  By default, an array of `[$type, $id]` is returned when decoding.
  You may limit this to returning just one of both.
  Allowed values: ARRAY, TYPE, ID
  """
  decode: String = ARRAY
) on FIELD_DEFINITION | INPUT_FIELD_DEFINITION | ARGUMENT_DEFINITION
GRAPHQL;
    }
}
