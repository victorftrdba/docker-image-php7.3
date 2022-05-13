FROM php:7.3-apache

LABEL maintainer="Victor Nogueira"

RUN mkdir -p /app
WORKDIR /app
COPY . /app

RUN apt-get update \
    && apt-get install -y curl ca-certificates zip unzip git libcap2-bin libxml2-dev libpng-dev software-properties-common \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get -y --no-install-recommends install g++ zlib1g-dev \
    && pecl install grpc \
    && docker-php-ext-install dom pdo exif fileinfo json opcache \
    && docker-php-ext-enable grpc dom pdo exif fileinfo json opcache \
    && php /usr/bin/composer install

RUN groupadd --force -g 1000 sail
RUN useradd -ms /bin/bash --no-user-group -g 1000 -u 1337 sail

EXPOSE 8080

CMD php artisan serve --host=0.0.0.0 --port=80
