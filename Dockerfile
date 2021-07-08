FROM composer:1.10.22 as vendor

WORKDIR /tmp/

COPY composer.json composer.json
COPY composer.lock composer.lock
COPY database database

RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist

FROM php:7.4-fpm-alpine

COPY --from=vendor /tmp/vendor/ /var/www/html/vendor/

# Copy composer.lock and composer.json
#COPY composer.lock composer.json /var/www/

# Set working directory
WORKDIR /var/www

# Install dependencies
# RUN apt-get update && apt-get install -y \
#     build-essential \
#     libpng-dev \
#     libjpeg62-turbo-dev \
#     libfreetype6-dev \
#     locales \
#     zip \
#     jpegoptim optipng pngquant gifsicle \
#     vim \
#     unzip \
#     git \
#     curl

# Clear cache
# RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
# RUN docker-php-ext-install pdo pdo_pgsql mbstring zip exif pcntl opcache redis
# RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
# RUN docker-php-ext-install gd

# Install composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# # Add user for laravel application
# RUN groupadd -g 1000 www
# RUN useradd -u 1000 -ms /bin/bash -g www www

# # Copy existing application directory contents
# COPY . /var/www

# # Copy existing application directory permissions
# COPY --chown=www:www . /var/www

# # Change current user to www
# USER www

# Expose port 9000 and start php-fpm server
CMD ["php-fpm", "-F"]

EXPOSE 9000