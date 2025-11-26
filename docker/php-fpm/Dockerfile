# -------------------------------
# Stage 1: Build
# -------------------------------
FROM php:8.4-fpm AS build

# Install system dependencies for PHP extensions and Composer
RUN apt-get update && apt-get install -y --no-install-recommends \
    libzip-dev libonig-dev zip unzip bash git curl \
    && docker-php-ext-install pdo pdo_mysql mbstring zip bcmath \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/html

# Copy application code
COPY . .

# Install Composer (production only)
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

# Set ownership & permissions
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Copy entrypoint
COPY --from=build /entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint and run PHP-FPM
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]

