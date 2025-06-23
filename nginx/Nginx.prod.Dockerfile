ARG NGINX_VERSION=1.25.2
FROM nginx:${NGINX_VERSION} as nginx

ARG PRJ_NAME=my-coding-project
ARG APP_CODE_PATH_CONTAINER=/var/www/html
ARG NGINX_SITES_PATH_PROD=./nginx/sites/

WORKDIR ${APP_CODE_PATH_CONTAINER}

COPY --chown=wwwuser:wwwgroup ../.. .

RUN rm -f /etc/nginx/conf.d/default.conf

COPY ${NGINX_SITES_PATH_PROD} /etc/nginx/conf.d/