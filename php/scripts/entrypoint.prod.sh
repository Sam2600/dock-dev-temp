#!/bin/bash

if [ ! -f "vendor/autoload.php" ]; then
   composer install --no-ansi --no-dev --no-interaction --no-plugins --no-progress --no-scripts --optimize-autoloader
fi

if [ ! -f ".env" ]; then
   echo "Creating env file..."
   cp .env.example .env
else
   echo "Env file exists."
fi

# php artisan migrate
php artisan optimize:clear
php artisan migrate

# Fix files ownership.
chown -R wwwuser .
chown -R wwwuser /app/storage
chown -R wwwuser /app/storage/logs
chown -R wwwuser /app/storage/framework
chown -R wwwuser /app/storage/framework/sessions
chown -R wwwuser /app/bootstrap
chown -R wwwuser /app/bootstrap/cache

# Set correct permission.
chmod -R 775 /app/storage
chmod -R 775 /app/storage/logs
chmod -R 775 /app/storage/framework
chmod -R 775 /app/storage/framework/sessions
chmod -R 775 /app/bootstrap
chmod -R 775 /app/bootstrap/cache

exec php-fpm