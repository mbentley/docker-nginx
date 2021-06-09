FROM mbentley/nginx:latest

COPY default /etc/nginx/sites-available/default
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx","-c","/etc/nginx/nginx.conf"]
