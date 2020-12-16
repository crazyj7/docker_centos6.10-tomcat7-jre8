########################
# CentOS 6.10
# JDK1.8
# tomcat7.0.107
########################


FROM centos:centos6.10
MAINTAINER crazyj7@gmail.com


############################
# yum update
#
# centos 6 ended in Nov.2020 
#
#	mkdir -p /var/cache/yum/x86_64/6/centos-sclo-rh && \
#	mkdir -p /var/cache/yum/x86_64/6/centos-sclo-sclo && \
#	echo "http://vault.centos.org/6.10/os/x86_64/" > /var/cache/yum/x86_64/6/base/mirrorlist.txt && \
#	echo "http://vault.centos.org/6.10/extras/x86_64/" > /var/cache/yum/x86_64/6/extras/mirrorlist.txt && \
#	echo "http://vault.centos.org/6.10/updates/x86_64/" > /var/cache/yum/x86_64/6/updates/mirrorlist.txt && \
# echo "https://vault.centos.org/6.10/centos-sclo-rh/x86_64/" > /var/cache/yum/x86_64/6/centos-sclo-rh/mirrorlist.txt && \
#	echo "https://vault.centos.org/6.10/centos-sclo-sclo/x86_64/" > /var/cache/yum/x86_64/6/centos-sclo-sclo/mirrorlist.txt

RUN mkdir -p /var/cache/yum/x86_64/6/base && \
	mkdir -p /var/cache/yum/x86_64/6/extras && \
	mkdir -p /var/cache/yum/x86_64/6/updates && \
	echo "http://mirror.nsc.liu.se/centos-store/6.10/os/x86_64/" > /var/cache/yum/x86_64/6/base/mirrorlist.txt && \
	echo "http://mirror.nsc.liu.se/centos-store/6.10/extras/x86_64/" > /var/cache/yum/x86_64/6/extras/mirrorlist.txt && \
	echo "http://mirror.nsc.liu.se/centos-store/6.10/updates/x86_64/" > /var/cache/yum/x86_64/6/updates/mirrorlist.txt 
#
# RUN yum --disablerepo=* --enablerepo=base,extras,updates update
# RUN yum -y --enablerepo=base,extras,updates install sudo

############################
# sudo
RUN yum -y install sudo

############################
# JDK
WORKDIR /usr/java
RUN yum -y install java-1.8.0-openjdk-devel.x86_64
WORKDIR /usr/java
RUN ln -s /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.275.b01-0.el6_10.x86_64 latest

############################
# TOMCAT 
# install path ; /usr/share/tomcat7
WORKDIR /usr/local
ADD https://downloads.apache.org/tomcat/tomcat-7/v7.0.107/bin/apache-tomcat-7.0.107.tar.gz /usr/local
RUN tar xvfz apache-tomcat-7.0.107.tar.gz
RUN /bin/ln -s /usr/local/apache-tomcat-7.0.107 /usr/local/tomcat

############################
# env
WORKDIR /root
ENV CATALINA_HOME=/usr/local/tomcat
ENV JAVA_HOME=/usr/java/latest
ENV JRE_HOME=/usr/java/latest/jre
ENV LD_LIBRARY_PATH=.:/usr/local/lib:$JAVA_HOME/bin:$CATALINA_HOME/bin
ENV PATH=$PATH:/usr/java/latest/bin
ENV HOME /root
VOLUME ["/usr/local/tomcat/webapps","/usr/local/lib"]
EXPOSE 8080

#CMD ["/bin/bash"]
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]

