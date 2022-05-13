FROM ubuntu:22.04

LABEL maintainer="Victor Nogueira"

RUN mkdir -p /app
WORKDIR /app
COPY . /app

ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get install -y gnupg gosu curl ca-certificates zip unzip git libcap2-bin libxml2-dev libpng-dev software-properties-common \
    && mkdir -p ~/.gnupg \
    && chmod 600 ~/.gnupg \
    && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
    && apt-key adv --homedir ~/.gnupg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E5267A6C \
    && apt-key adv --homedir ~/.gnupg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C300EE8C \
    && add-apt-repository ppa:ondrej/php -y \
    && apt-get update \
    && apt-get install -y php7.3-cli php7.3-dev \
       php7.3-sqlite3 php7.3-gd \
       php7.3-curl php7.3-memcached \
       php7.3-imap php7.3-mbstring \
       php7.3-xml php7.3-zip php7.3-bcmath php7.3-soap \
       php7.3-intl php7.3-readline php7.3-pcov \
       php7.3-msgpack php7.3-igbinary php7.3-ldap \
       php7.3-grpc php7.3-protobuf php7.3-redis php7.3-xdebug \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && php /usr/bin/composer install \
    && php artisan optimize:clear

RUN groupadd --force -g 1000 sail
RUN useradd -ms /bin/bash --no-user-group -g 1000 -u 1337 sail

EXPOSE 80

CMD php artisan serve --host=0.0.0.0 --port=80
