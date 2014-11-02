#!/bin/bash

docker run --name coubr-nginx -v ~/Developer/Repository/coubr/www:/usr/share/nginx/www:ro -v ~/Developer/Repository/coubr/www-business:/usr/share/nginx/www-business:ro -d nginx
