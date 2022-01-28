# mbentley/nginx-https-redirect

docker image for redirecting traffic to https using nginx
based off of mbentley/nginx:latest

To pull this image:
`docker pull mbentley/nginx-https-redirect`

Example usage:
`docker run -d -p 80:80 --name nginx-ssl-redirect mbentley/nginx-https-redirect`

By default, all requests are redirects to https to the same host and URI.
