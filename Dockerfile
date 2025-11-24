# Stage 1: Build
FROM php:8.2-fpm-alpine AS build

RUN apk add --no-cache \
    autoconf g++ make oniguruma-dev \
    libpng-dev libjpeg-turbo-dev freetype-dev libzip-dev zip unzip bash git curl \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app
COPY . .

RUN composer install --no-dev --optimize-autoloader \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

FROM php:8.2-fpm-alpine

# Install Nginx and other dependencies
RUN apk add --no-cache nginx bash libpng libjpeg-turbo freetype \
    && mkdir -p /run/nginx

# Copy Laravel app
WORKDIR /var/www/html
COPY --from=build /app /var/www/html

# Copy Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose HTTP (Gateway terminates TLS)
EXPOSE 80

# Start PHP-FPM and Nginx
CMD sh -c "php-fpm -F & nginx -g 'daemon off;'"
