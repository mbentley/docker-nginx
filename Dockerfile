# rebased/repackaged base image that only updates existing packages
FROM mbentley/alpine:latest
LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

ARG NGINX_VER
ARG NGINX_BRANCH=mainline

# drop in a hacky script to get the latest version of nginx
COPY get_nginx_latest_version.sh /get_nginx_latest_version.sh

# install build deps and then the runtime deps, download nginx source, compile, install, remove build deps
RUN apk add --no-cache bash curl jq &&\
  NGINX_VER="$(/get_nginx_latest_version.sh)" &&\
  rm /get_nginx_latest_version.sh &&\
  apk del bash curl jq &&\
  apk add --no-cache build-base ca-certificates linux-headers openssl-dev pcre-dev wget zlib-dev musl openssl pcre zlib &&\
  wget -q "http://nginx.org/download/nginx-${NGINX_VER}.tar.gz" -O "/tmp/nginx-${NGINX_VER}.tar.gz" &&\
  cd /tmp &&\
  tar zxvf "/tmp/nginx-${NGINX_VER}.tar.gz" &&\
  cd "/tmp/nginx-${NGINX_VER}" &&\
  ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=www-data \
    --group=www-data \
    --with-file-aio \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_mp4_module \
    --with-http_realip_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-stream \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-threads &&\
  make &&\
  make install &&\
  rm /etc/nginx/*.default &&\
  cd / &&\
  rm -rf "/tmp/nginx-${NGINX_VER}" "/tmp/nginx-${NGINX_VER}.tar.gz" &&\
  mkdir -p /var/cache/nginx /etc/nginx/sites-enabled /etc/nginx/sites-available /etc/nginx/streams-enabled /etc/nginx/streams-available /var/www &&\
  ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default &&\
  ln -sf /dev/stdout /var/log/nginx/access.log &&\
  ln -sf /dev/stderr /var/log/nginx/error.log &&\
  (deluser "$(grep ':33:' /etc/passwd | awk -F ':' '{print $1}')" || true) &&\
  (delgroup "$(grep '^www-data:' /etc/group | awk -F ':' '{print $1}')" || true) &&\
  addgroup -g 33 www-data &&\
  adduser -D -u 33 -G www-data -s /sbin/nologin -H -h /var/cache/nginx www-data &&\
  chown -R www-data:www-data /var/www &&\
  apk del build-base linux-headers openssl-dev pcre-dev wget zlib-dev

# include my default config files
COPY nginx.conf php.conf /etc/nginx/
COPY default /etc/nginx/sites-available/default
COPY entrypoint.sh /entrypoint.sh

# add an index.html
RUN echo "hello-world!" > /var/www/index.html

EXPOSE 80 443
#STOPSIGNAL SIGQUIT
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx","-c","/etc/nginx/nginx.conf"]
