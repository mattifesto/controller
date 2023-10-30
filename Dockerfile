#
# - - - - - - - - - - base - - - - - - - - - -
#

FROM php:8.2-apache AS base



# GD

RUN apt-get update
RUN apt-get install -y libfreetype6-dev
RUN apt-get install -y libjpeg62-turbo-dev
RUN apt-get install -y libpng-dev
RUN apt-get install -y libwebp-dev
RUN apt-get install -y zlib1g-dev

RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp

RUN docker-php-ext-install gd



# rewrite / htaccess

RUN a2enmod rewrite



#
# - - - - - - - - - - final-image - - - - - - - - - -
#

FROM base AS final-image

COPY tmp/build/* /var/www/html/



#
# - - - - - - - - - - development - - - - - - - - - -
#

FROM base AS development



# Debian - Install Git (MC v1)

RUN apt-get update
RUN apt-get -y install git
RUN git config --global pull.ff only



# make the "en_US.UTF-8" locale
# https://hub.docker.com/_/debian

RUN apt-get update
RUN apt-get install -y locales
RUN rm -rf /var/lib/apt/lists/*
RUN localedef \
    -i en_US \
    -c \
    -f UTF-8 \
    -A /usr/share/locale/locale.alias \
    en_US.UTF-8
ENV LANG en_US.utf8



# ack

RUN apt-get update
RUN apt-get install -y ack



# install PHP composer
# https://hub.docker.com/_/composer/

COPY --from=composer /usr/bin/composer /usr/bin/composer



# install zip tools for PHP composer
# comoposer technically works without this but takes longer and emits warnings

RUN apt-get update
RUN apt-get install -y libzip-dev
RUN apt-get install -y unzip
RUN docker-php-ext-install zip



# install docker
# https://docs.docker.com/engine/install/debian/

RUN apt-get update
RUN apt-get remove docker.io
RUN apt-get remove docker-compose
RUN apt-get remove docker-doc

# The linked instructions say to remove this but it isn't actually installed and
# causes an error when building the Docker image.
#
#   "Unable to locate package podman-docker"
#
# RUN apt-get remove podman-docker

RUN apt-get install -y ca-certificates
RUN apt-get install -y curl
RUN apt-get install -y gnupg

RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg

RUN echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update
RUN apt-get install -y docker-ce
RUN apt-get install -y docker-ce-cli
RUN apt-get install -y containerd.io
RUN apt-get install -y docker-buildx-plugin
RUN apt-get install -y docker-compose-plugin



# Install Node.js (MC v2)

RUN apt-get update
RUN apt-get install -y nodejs
RUN apt-get install -y npm



# Install JSHint (MC v1)

RUN npm install -g jshint
