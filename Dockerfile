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

# Stage 2: Runtime Nginx + PHP-FPM
FROM nginx:alpine
# Install PHP-FPM and extensions
RUN apk add --no-cache \
    php8 php8-fpm php8-opcache php8-gd php8-pdo php8-pdo_mysql php8-mbstring php8-zip bash \
    libpng libjpeg-turbo freetype

# Copy Laravel app
COPY --from=build /app /var/www/html

# Copy Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose HTTP (Gateway handles TLS)
EXPOSE 80

# Start PHP-FPM and Nginx
CMD sh -c "php-fpm8 -F & nginx -g 'daemon off;'"
