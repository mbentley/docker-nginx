mbentley/nginx
==================

docker image for nginx
based off of alpine:latest

To pull this image:
`docker pull mbentley/nginx`

Example usage:
`docker run -it -p 80 --name nginx -v /data/www:/var/www mbentley/nginx`

By default, this just runs a basic nginx server that listens on port 80.  The default webroot is `/var/www`.

### Environment variables
`FASTCGI_PASS` - (default - `unix:/var/run/php5-fpm.sock`) - Allows user to override the location used by fastcgi_pass in `/etc/nginx/php.conf`.
