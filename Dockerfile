FROM php:cli-alpine

WORKDIR /app

# Install Composer
COPY --from=composer/composer:latest-alpine /usr/bin/composer /usr/bin/composer

# Install Expose via Composer
RUN composer global require beyondcode/expose

# Add Expose to PATH
ENV PATH="/root/.composer/vendor/bin:${PATH}"

CMD ["expose"]
