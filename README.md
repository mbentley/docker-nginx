mbentley/nginx
==================

docker image for nginx
based off of alpine:latest

To pull this image:
`docker pull mbentley/nginx`

Example usage:
`docker run -it -p 80 --name nginx -v /data/www:/var/www mbentley/nginx`

By default, this just runs a basic nginx server that listens on port 80.  The default webroot is `/var/www`.
