FROM nginx:1.28.0 as nginx
COPY ./default.conf /etc/nginx/conf.d/default.conf
