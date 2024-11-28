FROM php:8.2-alpine

WORKDIR /var/www/html

RUN apk add --no-cache \
	git \
	curl \
    	libzip-dev \
    	unzip \
	icu-dev \
	libxml2-dev \
    	&& docker-php-ext-install zip pdo pdo_mysql intl

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 8000

COPY . .

RUN git config --global --add safe.directory /var/www/html

RUN composer install --ignore-platform-req=ext-gd

# RUN composer update

RUN php artisan key:generate

CMD php artisan migrate && \
    php artisan db:seed && \
    php artisan key:generate && \
    php artisan storage:link && \
    php artisan serve --host=0.0.0.0 --port=8000
