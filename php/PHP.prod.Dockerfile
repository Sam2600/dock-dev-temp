ARG PHP_SUFFIX=fpm
ARG PHP_VERSION=8.2.28

FROM php:${PHP_VERSION}-${PHP_SUFFIX} as php

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        netcat-traditional \
        net-tools \
        libicu-dev \
        postgresql-client \
        libzip-dev \
        libonig-dev \
        gettext \
        zlib1g-dev \
        libcurl4-openssl-dev \
        libpq-dev && \
    docker-php-ext-install intl curl fileinfo gettext mbstring exif pdo_mysql pdo_pgsql pgsql zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create app user and group
RUN groupadd -g 1000 wwwgroup && \
    useradd -u 1000 -g wwwgroup -s /bin/bash -m wwwuser

# Copy entrypoint script 
COPY ./dock-dev-temp/php/scripts/entrypoint.prod.sh /scripts/entrypoint.prod.sh

# Set permissions for script
RUN sed -i 's/\r$//' /scripts/entrypoint.prod.sh && \
    chmod +x /scripts/entrypoint.prod.sh

# Set working directory
ARG WORKDIR=/var/www/html
WORKDIR ${WORKDIR}

# Copy your app code to the container and set permissions and ownership
ARG PRJ_NAME=my-coding-project
COPY --chown=wwwuser:wwwgroup ../.. .

# Switch to non-root user
USER wwwuser

ENTRYPOINT [ "/scripts/entrypoint.prod.sh" ]