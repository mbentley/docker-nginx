FROM mbentley/nginx:latest
LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

RUN echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories &&\
apk add --no-cache bind-tools imagemagick php81 php81-bcmath php81-bz2 php81-ctype php81-curl php81-exif php81-fileinfo php81-gd php81-fpm php81-gettext php81-gmp php81-iconv php81-intl php81-imap php81-json php81-ldap php81-mbstring php81-mysqli php81-pecl-apcu php81-pecl-igbinary php81-pecl-imagick php81-pecl-mcrypt@edge php81-pecl-memcached php81-pecl-redis php81-pdo php81-pdo_mysql php81-opcache php81-pdo_pgsql php81-pgsql php81-pcntl php81-posix php81-simplexml php81-xml php81-xmlreader php81-xmlwriter php81-zip s6 ssmtp wget whois &&\
  mkdir /etc/supervisor.d &&\
  sed -i 's/post_max_size = 8M/post_max_size = 16M/g' /etc/php81/php.ini &&\
  sed -i "s#upload_max_filesize = 2M#upload_max_filesize = 8M#g" /etc/php81/php.ini &&\
  sed -i "s#listen = 127.0.0.1:9000#listen = /var/run/php/php-fpm81.sock#g" /etc/php81/php-fpm.d/www.conf &&\
  sed -i "s#^;listen.owner = nobody#listen.owner = www-data#g" /etc/php81/php-fpm.d/www.conf &&\
  sed -i "s#^;listen.group = nobody#listen.group = www-data#g" /etc/php81/php-fpm.d/www.conf &&\
  sed -i "s#^;listen.mode = 0660#listen.mode = 0660#g" /etc/php81/php-fpm.d/www.conf &&\
  sed -i "s#^user = nobody#user = www-data#g" /etc/php81/php-fpm.d/www.conf &&\
  sed -i "s#^group = nobody#group = www-data#g" /etc/php81/php-fpm.d/www.conf

ENV FASTCGI_PASS="unix:/var/run/php/php-fpm81.sock"
COPY default /etc/nginx/sites-available/default
COPY s6 /etc/s6

RUN mkdir /var/run/php &&\
  chown -R www-data:www-data /var/log/php81 /var/run/php

EXPOSE 80
CMD ["s6-svscan","/etc/s6"]
