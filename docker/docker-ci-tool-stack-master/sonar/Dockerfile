#
# Creates a docker container with SonarQube, incl. several plugins
# Since the original Dockerfile does not support plugins, I
# had to extend the Dockerfile
#
# Original: https://hub.docker.com/_/sonarqube/
#

FROM eric/java:openjdk-8u45

MAINTAINER Eric Manley <compdude@charter.net>

ENV SONARQUBE_HOME /opt/sonarqube

# Http port
EXPOSE 9000

# H2 Database port
EXPOSE 9092

# Database configuration
# Defaults to using H2

ENV SONARQUBE_JDBC_USERNAME sonar
ENV SONARQUBE_JDBC_PASSWORD sonar

# For Docker Portability
# Use this for Linux Host
ENV SONARQUBE_JDBC_URL jdbc:h2:tcp://localhost:9092/sonar

# Use this for MAC docker-machine host
# ENV SONARQUBE_JDBC_URL jdbc:h2:tcp://192.168.99.100:9092/sonar
# ENV SONARQUBE_JDBC_URL jdbc:h2:tcp://"$DOCKER_HOST_IP":9092/sonar

ENV SONAR_VERSION 5.1.2

ENV SONAR_DOWNLOAD_URL https://sonarsource.bintray.com/Distribution

# pub   2048R/D26468DE 2015-05-25
#      Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
# uid       [ unknown] sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
# sub   2048R/06855C1D 2015-05-25

# RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE

# RUN set -x \
# 	&& cd /opt \
# 	&& curl -o sonarqube.zip -fSL http://downloads.sonarsource.com/sonarqube/sonarqube-$SONAR_VERSION.zip \
# 	&& curl -o sonarqube.zip.asc -fSL http://downloads.sonarsource.com/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
# 	&& gpg --verify sonarqube.zip.asc \
# 	&& unzip sonarqube.zip \
# 	&& mv sonarqube-$SONAR_VERSION sonarqube \
#  && rm sonarqube.zip* \
# 	&& rm -rf $SONARQUBE_HOME/bin/*

#
# Download (copy) & install Sonar.
#

COPY resources/sonarqube-$SONAR_VERSION.zip /opt/sonarqube.zip
COPY resources/sonarqube-$SONAR_VERSION.zip.asc /opt/sonarqube.zip.asc

RUN set -x \
	&& cd /opt \
 	&& unzip sonarqube.zip \
 	&& mv sonarqube-$SONAR_VERSION sonarqube \
   && rm sonarqube.zip* \
 	&& rm -rf $SONARQUBE_HOME/bin/*
	
# 
# Installing Plugins
#

COPY resources/sonar-java-plugin-3.5.jar /opt/sonarqube/extensions/plugins/sonar-java-plugin-3.5.jar
COPY resources/sonar-web-plugin-2.4.jar /opt/sonarqube/extensions/plugins/sonar-web-plugin-2.4.jar
COPY resources/sonar-scm-git-plugin-1.1.jar /opt/sonarqube/extensions/plugins/sonar-scm-git-plugin-1.1.jar

VOLUME ["$SONARQUBE_HOME/data", "$SONARQUBE_HOME/extensions"]

WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/
RUN chmod +x $SONARQUBE_HOME/bin/run.sh

ENTRYPOINT ["./bin/run.sh"]
