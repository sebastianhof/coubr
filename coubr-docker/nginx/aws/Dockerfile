#
# cobra nginx Dockerfile
#
FROM nginx:latest

MAINTAINER Sebastian Hof <mail@sebastianhof.com>

# nothing to do here

COPY nginx.conf /etc/nginx/
COPY coubr-business.crt /etc/nginx/ssl/
COPY coubr-business.key /etc/nginx/ssl/
COPY coubr-api.crt /etc/nginx/ssl/
COPY coubr-api.key /etc/nginx/ssl/
