<?php

namespace App\GraphQL\Providers;

use App\GraphQL\WhereConditions\SimilarRouteOperator;
use Illuminate\Support\ServiceProvider;
use Nuwave\Lighthouse\WhereConditions\Operator;

class GraphQLServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->bind(Operator::class, SimilarRouteOperator::class);
    }
}
