#
# cobra Tomcat Base Dockerfile
#
# Derived from: dockerfile/java
# Derived from: tutumcloud/tutum-docker-tomcat
#

FROM ubuntu:latest
MAINTAINER Sebastian Hof <mail@sebastianhof.com>

# Set java home environment variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# Install java
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
	apt-get update && \
	apt-get install -yq software-properties-common && \
	add-apt-repository -y ppa:webupd8team/java && \
	apt-get update && \ 
	apt-get install -yq --no-install-recommends oracle-java7-installer wget ca-certificates && \
	apt-get clean && \
	rm -rf /var/cache/oracle-jdk7-installer \
    rm -rf /var/lib/apt/lists/*

# Set tomcat environment variable
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.0.14
ENV CATALINA_HOME /tomcat

# Set MySQL environment
ENV MYSQL_USER coubr
ENV MYSQL_PASSWORD Tub4noC4jUp4oK1gHod6nEef8tHiv3cigHs9iF6z
ENV MYSQL_DATABASE coubr

# Install tomcat
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
	wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \         
	tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat

# Configure tomcat
RUN ln -s ${CATALINA_HOME}/bin/catalina.sh catalina && \
    mv catalina /usr/bin
ADD keystore /
ADD context.xml /$CATALINA_HOME/conf/
ADD server.xml /$CATALINA_HOME/conf/
ADD tomcat-users.xml /$CATALINA_HOME/conf/
ADD web.xml /$CATALINA_HOME/conf/



