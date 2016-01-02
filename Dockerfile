FROM alpine:latest
MAINTAINER Matt Bentley <mbentley@mbentley.net>

RUN apk add --update ca-certificates nginx && rm -rf /var/cache/apk/* &&\
  rm -rf /etc/nginx/*.default &&\
  cp /usr/share/nginx/html/index.html /var/www/ &&\
  mkdir /etc/nginx/sites-available /etc/nginx/sites-enabled &&\
  ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default &&\
  ln -sf /dev/stdout /var/log/nginx/access.log &&\
  ln -sf /dev/stderr /var/log/nginx/error.log &&\
  deluser xfs &&\
  delgroup www-data &&\
  addgroup -g 33 www-data &&\
  adduser -D -u 33 -G www-data -s /sbin/nologin -H -h /var/www www-data

COPY nginx.conf php.conf /etc/nginx/
COPY default /etc/nginx/sites-available/default

VOLUME ["/var/lib/nginx/tmp"]
EXPOSE 80 443
CMD ["nginx","-c","/etc/nginx/nginx.conf"]
