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
php artisan storage:link

# Only run migrate:fresh --seed if explicitly enabled
if [ "$RUN_SEED" = "true" ] && [ "$HEALTH_CHK" = "true" ]; then

   if [ -z "$HEALTH_SERVER" ] || [ -z "$HEALTH_PORT" ]; then
      echo "Error: HEALTH_SERVER and HEALTH_PORT environment variables must be set."
      exit 1
   fi

   echo "Waiting for Database Server to be ready..."

   until nc -z -v -w30 "${HEALTH_SERVER}" "${HEALTH_PORT}"; do
      echo "⏳ Waiting for Database Server..."
      sleep 3
   done

   echo "✅ Database Server is ready! Continuing..."

   echo "Running migrations and seeding the database..."

   php artisan migrate:fresh --seed
   
else
   echo "Skipping migrations and seeding."
fi

exec php-fpm