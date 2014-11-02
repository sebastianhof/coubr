#!/bin/bash

docker stop coubr-tomcat
docker stop coubr-mysql

docker rm coubr-tomcat
docker rm coubr-mysql