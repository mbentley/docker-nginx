# mbentley/nginx

docker image for nginx
based off of alpine:latest

To pull this image:
`docker pull mbentley/nginx`

Example usage:
`docker run -it -p 80 --name nginx -v /data/www:/var/www mbentley/nginx`

By default, this just runs a basic nginx server that listens on port 80.  The default webroot is `/var/www`.

## Environment variables

- `FASTCGI_PASS` - (default - `unix:/var/run/php8-fpm.sock`) - Allows user to override the location used by fastcgi_pass in `/etc/nginx/php.conf`.
  - Example: `unix:/run/php/php8.0-fpm.sock` for php8.0-fpm
  - Example: `php:9000` where php8-fpm is listening on port 9000 on an overlay network where the service is named `php`
