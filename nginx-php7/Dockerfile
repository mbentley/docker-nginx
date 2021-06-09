FROM mbentley/nginx:latest
MAINTAINER Matt Bentley <mbentley@mbentley.net>

RUN echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories &&\
  apk add --no-cache bind-tools imagemagick@edge php7 php7-bz2 php7-ctype php7-curl php7-exif php7-fileinfo php7-gd php7-fpm php7-gettext php7-gmp php7-iconv php7-imagick php7-intl php7-imap php7-json php7-ldap php7-mbstring php7-mcrypt php7-memcached php7-mysqli php7-pecl-apcu php7-pecl-igbinary php7-pecl-imagick php7-pecl-redis php7-pdo php7-pdo_mysql php7-pdo_pgsql php7-pgsql php7-pcntl php7-posix php7-simplexml php7-xml php7-xmlreader php7-xmlwriter php7-zip s6 ssmtp wget whois &&\
  mkdir /etc/supervisor.d &&\
  sed -i 's/post_max_size = 8M/post_max_size = 16M/g' /etc/php7/php.ini &&\
  sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /etc/php7/php.ini &&\
  sed -i "s#listen = 127.0.0.1:9000#listen = /var/run/php/php-fpm7.sock#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#;listen.owner = nobody#listen.owner = www-data#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#;listen.group = nobody#listen.group = www-data#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#^user = nobody#user = www-data#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#^group = nobody#group = www-data#g" /etc/php7/php-fpm.d/www.conf

ENV FASTCGI_PASS="unix:/var/run/php/php-fpm7.sock"
COPY default /etc/nginx/sites-available/default
COPY s6 /etc/s6

RUN mkdir /var/run/php &&\
  chown -R www-data:www-data /var/log/php7 /var/run/php

EXPOSE 80
CMD ["s6-svscan","/etc/s6"]
