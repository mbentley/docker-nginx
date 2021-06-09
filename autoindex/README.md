mbentley/nginx-autoindex
========================

docker image for nginx with autoindex on by default
based off of mbentley/nginx:latest

To pull this image:
`docker pull mbentley/nginx-autoindex`

Example usage:
`docker run -it -p 80 --name nginx -v /data/www:/var/www mbentley/nginx-autoindex`

By default, this just runs a basic nginx server that listens on port 80 with autoindex on.  The default webroot is `/var/www`.

### Environment variables
- `FASTCGI_PASS` - (default - `unix:/var/run/php5-fpm.sock`) - Allows user to override the location used by fastcgi_pass in `/etc/nginx/php.conf`.
  - Example: `unix:/run/php/php7.0-fpm.sock` for php7.0-fpm
  - Example: `php:9000` where php5-fpm is listening on port 9000 on an overlay network where the service is named `php`
