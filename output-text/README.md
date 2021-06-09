# mbentley/nginx-output-text

docker image for nginx; outputs a text string for any URI
based off of mbentley/nginx

To pull this image:
`docker pull mbentley/nginx-output-text`

Example usage:
`docker run -it -p 80:80 --name nginx-output-text -e OUTPUT_TEXT="hello world"  mbentley/nginx-output-text`

By default, this just runs a basic nginx server that listens on port 80 and returns the text "hello world" for any URI you try to access.  Change the text by changing the `OUTPUT_TEXT` environment variable.
