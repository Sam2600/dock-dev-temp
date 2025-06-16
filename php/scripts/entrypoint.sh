#!/bin/bash

if [ ! -d vendor ]; then
   composer install
fi

if [ ! -f ".env" ]; then
   echo "Creating an env file..."
   cp env.example .env
else
   echo "Env file is found."
fi

php artisan optimize:clear
php artisan key:generate

# Run PHP-FPM in the foreground so the container stays alive
exec php-fpm