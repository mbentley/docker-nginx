# rebased/repackaged base image that only updates existing packages
FROM mbentley/alpine:3.15
LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

ARG NGINX_VER

# drop in a hacky script to get the latest version of stable nginx
COPY get_nginx_latest_stable_version.sh /get_nginx_latest_stable_version.sh

# install build deps and then the runtime deps, download nginx source, compile, install, remove build deps
RUN apk add --no-cache bash curl jq &&\
  NGINX_VER="$(/get_nginx_latest_stable_version.sh)" &&\
  rm /get_nginx_latest_stable_version.sh &&\
  apk del bash curl jq &&\
  apk add --no-cache build-base ca-certificates linux-headers openssl-dev pcre-dev wget zlib-dev musl openssl pcre zlib &&\
  wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz -O /tmp/nginx-${NGINX_VER}.tar.gz &&\
  cd /tmp &&\
  tar zxvf /tmp/nginx-${NGINX_VER}.tar.gz &&\
  cd /tmp/nginx-${NGINX_VER} &&\
  ./configure \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --pid-path=/nginx.pid \
    --lock-path=/var/lock/nginx.lock \
    --http-log-path=/var/log/nginx/access.log \
    --with-http_dav_module \
    --http-client-body-temp-path=/var/lib/nginx/body \
    --with-http_ssl_module \
    --with-http_realip_module \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --with-http_stub_status_module \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --with-file-aio \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_flv_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_mp4_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-stream \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-threads \
    --user=www-data \
    --group=www-data &&\
  make &&\
  make install &&\
  rm /etc/nginx/*.default &&\
  cd / &&\
  rm -rf /tmp/nginx-${NGINX_VER} /tmp/nginx-${NGINX_VER}.tar.gz &&\
  mkdir -p /var/lib/nginx /etc/nginx/sites-enabled /etc/nginx/sites-available /etc/nginx/streams-enabled /etc/nginx/streams-available /var/www &&\
  ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default &&\
  ln -sf /dev/stdout /var/log/nginx/access.log &&\
  ln -sf /dev/stderr /var/log/nginx/error.log &&\
  deluser $(grep ':33:' /etc/passwd | awk -F ':' '{print $1}') || true  &&\
  delgroup $(grep '^www-data:' /etc/group | awk -F ':' '{print $1}') || true &&\
  addgroup -g 33 www-data &&\
  adduser -D -u 33 -G www-data -s /sbin/nologin -H -h /var/www www-data &&\
  chown -R www-data:www-data /var/www &&\
  apk del build-base linux-headers openssl-dev pcre-dev wget zlib-dev

# include my default config files
COPY nginx.conf php.conf /etc/nginx/
#COPY default /etc/nginx/sites-available/default
COPY entrypoint.sh /entrypoint.sh

# add an index.html
RUN echo "hello-world!" > /var/www/index.html

# install php7
RUN apk add --no-cache bind-tools imagemagick php7 php7-bz2 php7-ctype php7-curl php7-exif php7-fileinfo php7-gd php7-fpm php7-gettext php7-gmp php7-iconv php7-imagick php7-intl php7-imap php7-json php7-ldap php7-mbstring php7-mcrypt php7-memcached php7-mysqli php7-pecl-apcu php7-pecl-igbinary php7-pecl-imagick php7-pecl-redis php7-pdo php7-pdo_mysql php7-pdo_pgsql php7-pgsql php7-pcntl php7-posix php7-simplexml php7-xml php7-xmlreader php7-xmlwriter php7-zip s6 ssmtp wget whois &&\
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

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["s6-svscan","/etc/s6"]
