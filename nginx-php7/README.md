mbentley/nginx-php7
===================

docker image for nginx + php7-fpm
based off of mbentley/nginx

To pull this image:
`docker pull mbentley/nginx-php7`

Example usage:
`docker run -i -t -p 80 -v /data/logs:/var/log/nginx -v /data/www:/var/www mbentley/nginx-php7`

By default, this just runs a basic nginx server that listens on port 80.  The default webroot is `/var/www`.

Note:  There are a number of packages that have been installed here that are certainly not required for php7 or nginx but are added for specific use cases that require the additional packages.

Also, please be aware that this isn't exactly an ideal configuration using php7-fpm and nginx in a single container while running with supervisor.  Please see [mbentley/php7-fpm](https://github.com/mbentley/docker-php7-fpm) for instructions on how to make php7-fpm and nginx work together in separate containers.
