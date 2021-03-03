FROM alpine:latest
MAINTAINER Matt Bentley <mbentley@mbentley.net>

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
    --with-http_auth_request_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-stream \
    --with-stream_ssl_module \
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
  deluser xfs &&\
  addgroup -g 33 www-data &&\
  adduser -D -u 33 -G www-data -s /sbin/nologin -H -h /var/www www-data &&\
  chown -R www-data:www-data /var/www &&\
  apk del build-base linux-headers openssl-dev pcre-dev wget zlib-dev

# include my default config files
COPY nginx.conf php.conf /etc/nginx/
COPY default /etc/nginx/sites-available/default
COPY entrypoint.sh /entrypoint.sh

# add an index.html
RUN echo "hello-world!" > /var/www/index.html

EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx","-c","/etc/nginx/nginx.conf"]
