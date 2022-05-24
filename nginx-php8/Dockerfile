FROM mbentley/nginx:latest
LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

RUN apk add --no-cache bind-tools imagemagick php8 php8-bcmath php8-bz2 php8-ctype php8-curl php8-exif php8-fileinfo php8-gd php8-fpm php8-gettext php8-gmp php8-iconv php8-intl php8-imap php8-json php8-ldap php8-mbstring php8-mysqli php8-pecl-apcu php8-pecl-igbinary php8-pecl-imagick php8-pecl-mcrypt php8-pecl-memcached php8-pecl-redis php8-pdo php8-pdo_mysql php8-opcache php8-pdo_pgsql php8-pgsql php8-pcntl php8-posix php8-simplexml php8-xml php8-xmlreader php8-xmlwriter php8-zip s6 ssmtp wget whois &&\
  mkdir /etc/supervisor.d &&\
  sed -i 's/post_max_size = 8M/post_max_size = 16M/g' /etc/php8/php.ini &&\
  sed -i "s#upload_max_filesize = 2M#upload_max_filesize = 8M#g" /etc/php8/php.ini &&\
  sed -i "s#listen = 127.0.0.1:9000#listen = /var/run/php/php-fpm8.sock#g" /etc/php8/php-fpm.d/www.conf &&\
  sed -i "s#^;listen.owner = nobody#listen.owner = www-data#g" /etc/php8/php-fpm.d/www.conf &&\
  sed -i "s#^;listen.group = nobody#listen.group = www-data#g" /etc/php8/php-fpm.d/www.conf &&\
  sed -i "s#^;listen.mode = 0660#listen.mode = 0660#g" /etc/php8/php-fpm.d/www.conf &&\
  sed -i "s#^user = nobody#user = www-data#g" /etc/php8/php-fpm.d/www.conf &&\
  sed -i "s#^group = nobody#group = www-data#g" /etc/php8/php-fpm.d/www.conf

ENV FASTCGI_PASS="unix:/var/run/php/php-fpm8.sock"
COPY default /etc/nginx/sites-available/default
COPY s6 /etc/s6

RUN mkdir /var/run/php &&\
  chown -R www-data:www-data /var/log/php8 /var/run/php

EXPOSE 80
CMD ["s6-svscan","/etc/s6"]
