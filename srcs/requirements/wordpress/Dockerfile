FROM debian:12

RUN apt-get update && \
    apt-get install -y wget php8.2-fpm php8.2-mysql default-mysql-client

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /run/php


RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' /etc/php/8.2/fpm/pool.d/www.conf

WORKDIR /var/www/html/

COPY init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 9000

ENTRYPOINT [ "/init.sh" ]