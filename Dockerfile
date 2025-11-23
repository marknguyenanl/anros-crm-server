# filepath: Dockerfile
FROM php:8.2-fpm-alpine AS build

# Install build dependencies
RUN apk add --no-cache \
    autoconf g++ make oniguruma-dev \
    libpng-dev libjpeg-turbo-dev freetype-dev libzip-dev zip unzip bash git curl
# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app

# Install PHP dependencies
COPY composer.json composer.lock ./
COPY artisan ./

RUN composer install --no-dev --optimize-autoloader

# Copy application code & optimize Laravel
COPY . .
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# Stage 2: Runtime
FROM php:8.2-fpm-alpine

# Install runtime dependencies including Nginx
RUN apk add --no-cache nginx libpng libjpeg freetype libzip zip unzip bash

WORKDIR /var/www/html

# Copy built app
COPY --from=build /app /var/www/html

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose HTTP port
EXPOSE 80

# Start PHP-FPM in background and Nginx in foreground
CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]

