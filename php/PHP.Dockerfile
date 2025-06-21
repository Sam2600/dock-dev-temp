ARG PHP_SUFFIX=fpm
ARG PHP_VERSION=8.2.28

FROM php:${PHP_VERSION}-${PHP_SUFFIX} as php

# Install system dependencies and PHP extensions
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libicu-dev \
        libzip-dev \
        libonig-dev \
        gettext \
        zlib1g-dev \
        libcurl4-openssl-dev && \
    docker-php-ext-install intl curl fileinfo gettext mbstring exif pdo_mysql zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create app user and group
RUN groupadd -g 1000 wwwgroup && \
    useradd -u 1000 -g wwwgroup -s /bin/bash -m wwwuser

# Copy entrypoint script 
COPY ./scripts/entrypoint.sh /scripts/entrypoint.sh

# Set permissions for script
RUN sed -i 's/\r$//' /scripts/entrypoint.sh && \
    chmod +x /scripts/entrypoint.sh

# Set working directory
ARG WORKDIR=/var/www/html
WORKDIR ${WORKDIR}

# Change ownership of working directory
RUN chown -R wwwuser:wwwgroup ${WORKDIR}

# Switch to non-root user
USER wwwuser

ENTRYPOINT [ "/scripts/entrypoint.sh" ]