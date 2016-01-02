FROM alpine:latest
MAINTAINER Matt Bentley <mbentley@mbentley.net>

ENV NGINX_VER 1.8.0

RUN apk add --update build-base ca-certificates openssl-dev pcre pcre-dev wget zlib-dev &&\
  wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz -O /tmp/nginx-${NGINX_VER}.tar.gz &&\
  cd /tmp &&\
  tar zxvf /tmp/nginx-${NGINX_VER}.tar.gz &&\
  cd /tmp/nginx-${NGINX_VER} &&\
  ./configure --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log \
    --pid-path=/nginx.pid --lock-path=/var/lock/nginx.lock --http-log-path=/var/log/nginx/access.log --with-http_dav_module \
    --http-client-body-temp-path=/var/lib/nginx/body --with-http_ssl_module --with-http_realip_module \
    --http-proxy-temp-path=/var/lib/nginx/proxy --with-http_stub_status_module --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --with-http_auth_request_module --user=www-data --group=www-data &&\
  make &&\
  make install &&\
  rm /etc/nginx/*.default &&\
  cd / &&\
  rm -rf /tmp/nginx-${NGINX_VER} /tmp/nginx-${NGINX_VER}.tar.gz &&\
  mkdir -p /var/lib/nginx /etc/nginx/sites-enabled /etc/nginx/sites-available /var/www &&\
  ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default &&\
  ln -sf /dev/stdout /var/log/nginx/access.log &&\
  ln -sf /dev/stderr /var/log/nginx/error.log &&\
  deluser xfs &&\
  addgroup -g 33 www-data &&\
  adduser -D -u 33 -G www-data -s /sbin/nologin -H -h /var/www www-data &&\
  apk del build-base openssl-dev pcre-dev wget zlib-dev && rm -rf /var/cache/apk/*

COPY nginx.conf php.conf /etc/nginx/
COPY default /etc/nginx/sites-available/default

VOLUME ["/var/lib/nginx"]
EXPOSE 80 443
CMD ["nginx","-c","/etc/nginx/nginx.conf"]
