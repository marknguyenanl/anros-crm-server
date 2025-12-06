<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Cross-Origin Resource Sharing (CORS) Configuration
    |--------------------------------------------------------------------------
    |
    | Here you may configure your settings for cross-origin resource sharing
    | or "CORS". This determines what cross-origin operations may execute
    | in web browsers. You are free to adjust these settings as needed.
    |
    | To learn more: https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
    |
    */

    'paths' => ['api/*', 'crm/*', 'sanctum/csrf-cookie'],

    'allowed_origins' => [],

    'allowed_origins_patterns' => [
        // Allow localhost on any port
        '/^http:\/\/localhost(:[0-9]+)?$/',

        // Allow any subdomain of samiohome.com over http or https
        '/^https?:\/\/([a-z0-9-]+\.)*anrostech\.com$/i',
    ],
    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => false,

];
