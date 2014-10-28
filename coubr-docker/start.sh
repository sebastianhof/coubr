#!/bin/bash

docker run --name coubr-mysql --volumes-from coubr-data -d -p 3306:3306 coubr/mysql
docker run --name coubr-tomcat --link coubr-mysql:mysql -d -p 8080:8080 -p 8443:8443 coubr/tomcat catalina run