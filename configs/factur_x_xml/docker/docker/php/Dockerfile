# Use an official PHP image with the appropriate tag
FROM php:8.3.1-fpm

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

# Install php-cs-fixer
RUN curl -L https://cs.symfony.com/download/php-cs-fixer-v3.phar -o php-cs-fixer \
    && chmod a+x php-cs-fixer \
    && mv php-cs-fixer /usr/local/bin/php-cs-fixer

# Clean the system to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*