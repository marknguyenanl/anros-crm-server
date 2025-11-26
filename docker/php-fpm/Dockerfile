# Stage 1: just build composer deps
FROM php:8.4-fpm-alpine AS build

RUN apk add --no-cache bash git curl unzip

WORKDIR /var/www/html
COPY . .
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader

# Stage 2: final runtime image
FROM php:8.4-fpm-alpine

RUN apk add --no-cache \
    autoconf g++ make oniguruma-dev \
    libzip-dev zip unzip \
    libpng-dev libjpeg-turbo-dev freetype-dev \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install pdo pdo_mysql mbstring zip bcmath gd

WORKDIR /var/www/html
COPY --from=build /var/www/html /var/www/html

RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

COPY docker/php-fpm/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm", "-F"]

