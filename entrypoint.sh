#!/bin/sh

if [ -n "${FASTCGI_PASS}" ]
then
  echo "Setting 'fastcgi_pass ${FASTCGI_PASS};' in /etc/nginx/php.conf..."
  sed -i "s#fastcgi_pass unix:/var/run/php8-fpm.sock;#fastcgi_pass ${FASTCGI_PASS};#g" /etc/nginx/php.conf
else
  echo "FASTCGI_PASS not set; using default of 'unix:/var/run/php8-fpm.sock'..."
fi

echo "Executing '${*}'..."
exec "${@}"
