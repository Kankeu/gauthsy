<?php

namespace App\GraphQL\Exceptions;

use Exception;
use Nuwave\Lighthouse\Exceptions\RendersErrorsExtensions;

class GraphQLException extends Exception implements RendersErrorsExtensions
{
    /**
     * @var @string
     */
    private $errors;
    private $category;

    /**
     * CustomException constructor.
     *
     * @param string $message
     * @param array $errors
     * @param string $category
     */
    public function __construct(string $message, array $errors, string $category='custom')
    {
        parent::__construct($message);

        $this->errors = $errors;
        $this->category=$category;
    }

    /**
     * Returns true when exception message is safe to be displayed to a client.
     *
     * @api
     * @return bool
     */
    public function isClientSafe(): bool
    {
        return true;
    }

    /**
     * Returns string describing a category of the error.
     *
     * Value "graphql" is reserved for errors produced by query parsing or validation, do not use it.
     *
     * @api
     * @return string
     */
    public function getCategory(): string
    {
        return $this->category;
    }

    /**
     * Return the content that is put in the "extensions" part
     * of the returned error.
     *
     * @return array
     */
    public function extensionsContent(): array
    {
        return [
            'errors' => $this->errors,
        ];
    }
}
