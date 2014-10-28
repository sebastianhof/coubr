#!/bin/bash

docker run --name coubr-nginx -v nginx/www:/usr/share/nginx/html:ro -v nginx/nginx.conf:/etc/nginx/nginx.conf:ro -d nginx
