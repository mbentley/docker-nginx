FROM debian:jessie
MAINTAINER Matt Bentley <mbentley@mbentley.net>

ENV NGINX_VER 1.8.0
RUN (apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential libpcre3 libpcre3-dev libpcrecpp0 libssl-dev zlib1g-dev wget)

RUN (wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz -O /tmp/nginx-${NGINX_VER}.tar.gz &&\
  cd /tmp &&\
  tar xvf /tmp/nginx-${NGINX_VER}.tar.gz &&\
  cd /tmp/nginx-${NGINX_VER} &&\
  ./configure --sbin-path=/usr/local/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log \
    --pid-path=/nginx.pid --lock-path=/var/lock/nginx.lock --http-log-path=/var/log/nginx/access.log --with-http_dav_module \
    --http-client-body-temp-path=/var/lib/nginx/body --with-http_ssl_module --with-http_realip_module \
    --http-proxy-temp-path=/var/lib/nginx/proxy --with-http_stub_status_module --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --with-http_auth_request_module --user=www-data --group=www-data &&\
  cd /tmp/nginx-${NGINX_VER} &&\
  make &&\
  make install &&\
  rm /etc/nginx/*.default &&\
  rm -rf /tmp/nginx-${NGINX_VER} /tmp/nginx-${NGINX_VER}.tar.gz &&\
  mkdir -p /var/lib/nginx /etc/nginx/sites-enabled /etc/nginx/sites-available /var/www)

ADD nginx.conf /etc/nginx/nginx.conf
ADD php.conf /etc/nginx/php.conf
ADD default /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

RUN chown -R www-data:www-data /var/www

EXPOSE 80
ENTRYPOINT ["/usr/local/sbin/nginx"]
CMD ["-c","/etc/nginx/nginx.conf"]
