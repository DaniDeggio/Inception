FROM debian:bullseye

RUN apt-get update && apt-get upgrade
RUN apt-get install -y php7.4-fpm

CMD ["php-fpm", "-F"]