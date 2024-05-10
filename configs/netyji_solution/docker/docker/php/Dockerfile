# Use an official PHP image with the appropriate tag
FROM php:8.3.6-fpm
ARG GITHUB_TOKEN

# Update and install necessary packages with specific versions
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # Install essential packages
    apt-utils=2.6.1 \
    # Git
    git=1:2.39.2-1.1 \
    # Zip
    zip=3.0-13 \
    # Unzip
    unzip=6.0-28 \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add authentication for privately hosted packages and repositories
ENV COMPOSER_HOME /composer
ENV COMPOSER_AUTH "{\"github-oauth\":{\"github.com\":\"$GITHUB_TOKEN\"}}"

# Install PHP 8 extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync \
    && install-php-extensions exif bcmath pdo_mysql tokenizer xml zip gd intl

# Install php-cs-fixer
RUN curl -L https://cs.symfony.com/download/php-cs-fixer-v3.phar -o php-cs-fixer \
    && chmod a+x php-cs-fixer \
    && mv php-cs-fixer /usr/local/bin/php-cs-fixer

# Clean the system to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*