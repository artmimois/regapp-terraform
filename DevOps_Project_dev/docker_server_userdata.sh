#!/bin/bash
sudo su -
yum update -y
yum install docker -y
cat << EOF > /etc/hostname
dockerhost
EOF
init 6
sudo su -
service docker start
cat << EOF > Dockerfile
FROM ubuntu:latest
MAINTAINER ganeshthirumani
RUN mkdir /opt/tomcat/
WORKDIR /opt/tomcat/
RUN apt-get update && apt-get install -y curl
RUN curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz
RUN tar -xvzf apache-tomcat-9.0.65.tar.gz 
RUN mv apache-tomcat-9.0.65/* /opt/tomcat/.
WORKDIR /opt/docker-tomcat/tomcat/webapps
RUN curl -O -L https://github.com/AKSarav/SampleWebApp/raw/master/dist/SampleWebApp.war
EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
EOF
docker build -t mytomcat .
docker run -d --name mytomcat-server -p 8081:8080 mytomcat

vi /etc/ssh/sshd_config
service sshd reload