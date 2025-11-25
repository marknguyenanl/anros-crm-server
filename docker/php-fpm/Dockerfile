# Stage 1: Build
FROM php:8.4-fpm-alpine

RUN apk add --no-cache \
    autoconf g++ make oniguruma-dev \
    libpng-dev libjpeg-turbo-dev freetype-dev libzip-dev zip unzip bash git curl \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-install pdo pdo_mysql

WORKDIR /var/www/html

COPY . .

RUN composer install --no-dev --optimize-autoloader \
    && chown -R www-data:www-data /var/www

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["php-fpm", "-F"]
