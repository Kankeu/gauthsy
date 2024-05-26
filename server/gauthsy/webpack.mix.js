const mix = require('laravel-mix');
const path = require('path');
require('laravel-mix-alias');

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel application. By default, we are compiling the Sass
 | file for the application as well as bundling up all the JS files.
 |
 */

mix.js('resources/js/app.js', 'public/js')
    //.sass('resources/sass/app.scss', 'public/css')
    .webpackConfig({
        module: {
            rules: [{
                test: /\.(graphql|gql)$/,
                loader: 'graphql-tag/loader',
            }]
        },
        resolve:{
            alias:{
                '@': path.join(__dirname,'resources/js'),
                //'~': '/resources/sass',
                '@views': path.join(__dirname,'resources/js/views'),
                '@config': path.join(__dirname,'resources/js/config'),
                '@mixins': path.join(__dirname,'resources/js/mixins'),
                '@assets': path.join(__dirname,'resources/js/assets'),
                '@kernel': path.join(__dirname,'resources/js/kernel'),
                '@graphql': path.join(__dirname,'resources/js/graphql'),
                '@components': path.join(__dirname,'resources/js/components'),
                '@repositories': path.join(__dirname,'resources/js/repositories'),
                '*' :'*'
            }
        }
    }).extract(['apollo-cache-inmemory', 'apollo-client',
    'apollo-link-context', 'apollo-upload-client',
    'apollo-link-error', 'graphql', 'copy-text-to-clipboard',
    'graphql-tag', 'vue', 'vue-apollo', 'vue-router','downloadjs',
    'vue-timeago', 'vuetify', 'url-parse','vue-code-highlight']).vue();

if (mix.inProduction()) {
    mix.version();
}
