#!/bin/bash

# building
docker build -t "coubr/mysql" mysql/
docker build -t "coubr/tomcat" tomcat/

# creating data store
docker run --name coubr-data -d -v /var/lib/mysql coubr/mysql echo Creating data store
