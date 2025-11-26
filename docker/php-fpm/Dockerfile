# Stage 1: Build
# -------------------------------
FROM php:8.4-fpm AS build

# Install system dependencies for PHP extensions and composer
RUN apk add --no-cache \
    autoconf g++ make oniguruma-dev \
    libpng-dev libjpeg-turbo-dev freetype-dev libzip-dev zip unzip bash git curl

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql

# Set working directory
WORKDIR /var/www/html

# Copy application code
COPY . .

# Install composer dependencies (production only)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader

# Ensure Laravel storage & bootstrap/cache dirs exist and are writable
RUN mkdir -p storage/framework/{sessions,views,cache} bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Copy entrypoint script
COPY docker/php-fpm/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# -------------------------------
# Stage 2: Production
# -------------------------------
FROM php:8.4-fpm

# Set working directory
WORKDIR /var/www/html

# Copy app from build stage
COPY --from=build /var/www/html /var/www/html

# Set ownership & permissions again (if needed for volumes)
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Copy entrypoint
COPY --from=build /entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint and run PHP-FPM
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm", "-F"]

