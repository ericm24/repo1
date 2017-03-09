# 
# Configures Jenkins within docker container (Jenkins on Ubuntu).
#

FROM eric/jenkins:1.642.2

MAINTAINER Eric Manley <compdude@charter.net>

ARG DOCKER_HOST_IP
ENV DOCKER_HOST_IP ${DOCKER_HOST_IP:-127.0.0.1}

USER root

#############################################
# Setup the docker & jenkins users..
#############################################

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

#############################################
# Create dev2 dir structure...
#############################################

RUN mkdir -p /dev2/sh; \
    mkdir -p /dev2/ansible/config; \
    mkdir -p /dev2/ansible/inventory; \
    mkdir -p /dev2/ansible/mservice/master/rm-monitoring/test; \
    mkdir -p /data/txt;

#############################################
# Chown the /dev2 directory to docker..
#############################################
RUN chown -R docker /dev2

##############################################
# Setup SSH for Ansible
##############################################
RUN rm -rfv /root/.ssh; \
    mkdir /root/.ssh; \
  	 cd /root/.ssh; \
    cat /dev/zero | ssh-keygen -q -N ""; \
    cd;

#############################################
# Setup apt-get, add apt-utils, software-properties-common
#############################################
RUN apt-get clean; \
    apt-get -y update;

#
# Do NOT Combine These
#
RUN apt-get -y install apt-utils vim
RUN apt-get -y install software-properties-common
RUN apt-get -y install gdebi

#############################################
# Install Ansible
#############################################

COPY resources/jenkins/installers/ansible_1.9.4-1_all.deb /tmp/
RUN gdebi -n /tmp/ansible_1.9.4-1_all.deb

#
# Chown the /var/jenkins_home dir to docker...Sooo Docker Can Mount it!
#
RUN chown -R docker:root /var/jenkins_home

#############################################
# Install Chef-Client
#############################################

COPY resources/jenkins/installers/chef-client_12.12.15-1_amd64.deb /tmp/
RUN gdebi -n /tmp/chef-client_12.12.15-1_amd64.deb

###########################################
# Copy Ansible Config Files
###########################################
COPY resources/ansible/config/ansible.cfg /dev2/ansible/config/
COPY resources/ansible/config/ericsservers-ip /dev2/ansible/inventory/
COPY resources/sh/add_ssh_host /dev2/sh/add_ssh_host
COPY resources/ansible/test/pb.test.simple-ifconfig-command.yml /dev2/ansible/mservice/master/rm-monitoring/test/

#
# Chmod the add_ssh_host Script
#
RUN chmod 755 /dev2/sh/add_ssh_host


###########################################
# Jenkins Setup
###########################################
COPY resources/jenkins/plugins.txt /var/jenkins_home/plugins.txt

#
# Comment out the run below, to start Jenkins faster...
#
RUN /usr/local/bin/plugins.sh /var/jenkins_home/plugins.txt

#
# Remove any previous jobs
#
RUN rm -rfv /usr/share/jenkins/ref/jobs
RUN mkdir /usr/share/jenkins/ref/jobs

#
# Add Our Jenkins Test Jobs
#
COPY resources/jenkins/jobs/ /usr/share/jenkins/ref/jobs/

# Additional Jenkins Example Jobs (Reference only).
# COPY resources/jenkins/jobs/1-github-seed-job.xml /usr/share/jenkins/ref/jobs/1-github-seed-job/config.xml
# COPY resources/jenkins/jobs/2-job-dsl-seed-job.xml /usr/share/jenkins/ref/jobs/2-job-dsl-seed-job/config.xml
# COPY resources/jenkins/jobs/3-conference-app-seed-job.xml /usr/share/jenkins/ref/jobs/3-conference-app-seed-job/config.xml
# COPY resources/jenkins/jobs/4-selenium2-maven-test.xml /usr/share/jenkins/ref/jobs/4-selenium2-maven-test/config.xml
# COPY resources/jenkins/jobs/6-conference-app-ci.xml /usr/share/jenkins/ref/jobs/conference-app-1-ci/config.xml
# COPY resources/jenkins/jobs/6-conference-app-sonar-analysis.xml /usr/share/jenkins/ref/jobs/conference-app-2-sonar-analysis/config.xml
# COPY resources/jenkins/jobs/7-conference-app-monitoring-ci.xml /usr/share/jenkins/ref/jobs/conference-app-monitoring-1-ci/config.xml
# COPY resources/jenkins/jobs/7-conference-app-monitoring-sonar-analysis.xml /usr/share/jenkins/ref/jobs/conference-app-monitoring-2-sonar-analysis/config.xml

############################################
# MAIN Jenkins Config
############################################
COPY resources/jenkins/config/config.xml /usr/share/jenkins/ref/config.xml
#
# Jenkins Settings, i.e. Maven, Groovy, ...
#
COPY resources/jenkins/config/hudson.tasks.Maven.xml /usr/share/jenkins/ref/hudson.tasks.Maven.xml
COPY resources/jenkins/config/hudson.plugins.groovy.Groovy.xml /usr/share/jenkins/ref/hudson.plugins.groovy.Groovy.xml
COPY resources/jenkins/config/hudson.tasks.Mailer.xml /usr/share/jenkins/ref/hudson.tasks.Mailer.xml
COPY resources/jenkins/config/maven-global-settings-files.xml /usr/share/jenkins/ref/maven-global-settings-files.xml
COPY resources/jenkins/config/jenkins.model.JenkinsLocationConfiguration.xml /usr/share/jenkins/ref/jenkins.model.JenkinsLocationConfiguration.xml

#
# Do IP Swap on /usr/share version...
#
RUN sed -i -- 's/$TARGET_IP/'"${DOCKER_HOST_IP}"'/g' /usr/share/jenkins/ref/jenkins.model.JenkinsLocationConfiguration.xml


# SSH Keys & Credentials
COPY resources/jenkins/config/credentials.xml /usr/share/jenkins/ref/credentials.xml
COPY resources/ssh-keys/cd-demo /usr/share/jenkins/ref/.ssh/id_rsa
COPY resources/ssh-keys/cd-demo.pub /usr/share/jenkins/ref/.ssh/id_rsa.pub


# Try this
# USER jenkins

#
# Install Postfix Portion Take 2
#

RUN echo "postfix postfix/main_mailer_type string Internet site" > /data/txt/preseed.txt
RUN echo "postfix postfix/mailname string ${HOSTNAME}" >> /data/txt/preseed.txt

RUN debconf-set-selections /data/txt/preseed.txt

# postfix_2.11.3-1_amd64.deb
COPY resources/jenkins/installers/postfix_2.11.3-1_amd64.deb /tmp/

RUN DEBIAN_FRONTEND=noninteractive gdebi -n /tmp/postfix_2.11.3-1_amd64.deb


RUN postconf -e myhostname=${HOSTNAME}
RUN postconf -e mydestination="${HOSTNAME}, ${HOSTNAME}, rm-jenkins-docker, example.com, localhost.localdomain, localhost"
RUN postconf -e mail_spool_directory="/var/spool/mail/"
RUN postconf -e mailbox_command=""

#
# Install Mailutils
#

COPY resources/jenkins/installers/mailutils_2.99.98-2_amd64.deb /tmp/
RUN gdebi -n /tmp/mailutils_2.99.98-2_amd64.deb

RUN touch /var/log/mail.log

