ARG PHP_SUFIX=fpm
ARG PHP_VERSION=8.2.28

FROM php:${PHP_VERSION}-${PHP_SUFIX} as php

# Create app user (let's name it wwwuser)
RUN groupadd -g 1000 wwwgroup && \
    useradd -u 1000 -g wwwgroup -s /bin/bash -m wwwuser

# Install system dependencies for PHP extensions
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    libonig-dev \
    gettext \
    zlib1g-dev \
    libcurl4-openssl-dev \
    && docker-php-ext-install intl curl fileinfo gettext mbstring exif pdo_mysql zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY ./scripts/entrypoint.sh /scripts/entrypoint.sh
RUN chmod +x /scripts/entrypoint.sh

# Set working directory
ARG WORKDIR=/var/www/html
WORKDIR ${WORKDIR}

# Copy your app code (adjust as needed)
# Copy cmd is only for production step

# Change ownership of working directory
RUN chown -R wwwuser:wwwgroup ${WORKDIR}

# Switch to non-root user
USER wwwuser

ENTRYPOINT [ "/scripts/entrypoint.sh" ]