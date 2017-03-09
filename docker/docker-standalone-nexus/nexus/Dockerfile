##########################################################################
# Creates a docker container with Nexus Artifact Repository For CentOS7
##########################################################################

FROM       centos:centos7
MAINTAINER Eric Manley <compdude@charter.net>

############################
# Nexus Options
############################
ENV SONATYPE_WORK /sonatype-work
ENV NEXUS_VERSION 2.11.4-01
ENV CONTEXT_PATH /nexus

############################
# Java Options
############################

# ENV JAVA_VERSION 7u76

ENV JAVA_VERSION 8u91

ENV MAX_HEAP 768m
ENV MIN_HEAP 256m
ENV JAVA_OPTS -server -XX:MaxPermSize=192m -Djava.net.preferIPv4Stack=true
ENV LAUNCHER_CONF ./conf/jetty.xml ./conf/jetty-requestlog.xml

############################
# Install tar & createrepo
############################
RUN yum install -y \
  curl tar createrepo wget sudo \
  && yum clean all

############################
# Install Java
############################

COPY resources/jdk-${JAVA_VERSION}-linux-x64.rpm /var/tmp/

# RUN wget -P /var/tmp --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.rpm

RUN cd /var/tmp \
  && rpm -Ui jdk-${JAVA_VERSION}-linux-x64.rpm \
  && rm -rf jdk-${JAVA_VERSION}-linux-x64.rpm

############################
# Install Nexus!
############################
COPY resources/nexus-${NEXUS_VERSION}-bundle.tar.gz /var/tmp/

RUN mkdir -p /opt/sonatype/nexus \
  && cd /var/tmp \
  && tar -xvf nexus-${NEXUS_VERSION}-bundle.tar.gz \
  && mv /var/tmp/nexus-${NEXUS_VERSION}/* /opt/sonatype/nexus/ \
  && rm -rf /tmp/nexus-${NEXUS_VERSION}

############################
# Add nexus user as  UID 300
############################
RUN useradd -r -u 300 -m -c "nexus role account" -d ${SONATYPE_WORK} -s /bin/false nexus

############################
# Mount the ext volume.
############################
VOLUME ${SONATYPE_WORK}

EXPOSE 8081
WORKDIR /opt/sonatype/nexus
 
  
############################
# Create the start script.
############################
RUN echo "#!/bin/bash" > /opt/start-nexus.sh

RUN echo "java -Dnexus-work=${SONATYPE_WORK} -Dnexus-webapp-context-path=${CONTEXT_PATH} \
-Xms${MIN_HEAP} -Xmx${MAX_HEAP} \
-cp 'conf/:lib/*' ${JAVA_OPTS} \
org.sonatype.nexus.bootstrap.Launcher ${LAUNCHER_CONF}" >> /opt/start-nexus.sh

RUN chmod +x /opt/start-nexus.sh

USER nexus
####################### 
# Start Nexus on 8081
#######################
CMD ["/opt/start-nexus.sh"]
EXPOSE 8081
  
   