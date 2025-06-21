#!/bin/bash

set -e

if [ ! -f "vendor/autoload.php" ]; then
   composer install --no-ansi --no-dev --no-interaction --no-plugins --no-progress --no-scripts --optimize-autoloader
   echo "Composer dependencies installed."
else
   echo "Vendor directory is found."
fi

if [ ! -f ".env" ]; then
   echo "Creating env file..."
   cp .env.example .env
else
   echo "Env file exists."
fi

# php artisan migrate
php artisan optimize:clear

# Only run migrate:fresh --seed if explicitly enabled
if [ "$RUN_SEED" = "true" ]; then

   echo "Waiting for MySQL to be ready..."

   until nc -z -v -w30 mysql 3306; do
      echo "⏳ Waiting for MySQL..."
      sleep 3
   done

   echo "✅ MySQL is ready! Continuing..."

   echo "Running migrations and seeding the database..."

   php artisan migrate:fresh --seed
   
else
   echo "Skipping migrations and seeding."
fi

exec php-fpm