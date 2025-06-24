#!/bin/bash

set -e

if [ ! -d vendor ]; then
   composer install --no-progress
   echo "Composer dependencies installed."
else
   echo "Vendor directory is found."
fi

if [ ! -f ".env" ]; then
   echo "Creating an env file..."
   cp env.example .env
else
   echo "Env file is found."
fi

php artisan optimize:clear
php artisan key:generate
php artisan storage:link

# Only run migrate:fresh --seed if explicitly enabled
if [ "$RUN_SEED" = "true" ]; then
   echo "Running migrations and seeding the database..."
   php artisan migrate:fresh --seed
else
   echo "Skipping migrations and seeding."
fi

# Run PHP-FPM in the foreground so the container stays alive
exec php-fpm