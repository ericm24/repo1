# Ericm24 Repo1

Welcome to the Repo1 Git Repo! 

This repo contains artifacts for Orchestraton and a CI System (Jenkins, Nexus, SonarQube, and Selenium Grid) inside
Docker Containers.   

To give credit where credit is due, this Docker CI Setup was initially built off of:  
[Continouous Integration Platform] (https://blog.codecentric.de/en/2015/10/continuous-integration-platform-using-docker-container-jenkins-sonarqube-nexus-gitlab/ "Continouous Integration Platform")

## Notes:
-All containers where modified to leverage docker volumes to make data externally available.

-Yes, I have the .deb files located under ./installers.  This is to:
  1. Ensure the proper version is installed 
  2. Mitigate dep repos that go MIA until I get an Object-Storage solution.  My choice...

## Jenkins
The Jenkins Image is setup primary for Ansible Development, which includes the Ansible install as well as Postfix (for email notifications).

## Nexus
The nexus docker-volume WILL NOT work on a MAC. (At least with what I've tried...if you gotta an idea, I'm all for it!)
To get the nexus container to work with the docker volume, you must execute the following commands BEFORE you do the initial build on the Nexus Image.

userdel nexus
useradd -u 300 --user-group --system nexus
mkdir -p /mnt/dockervolumes/data/nexus && chown -R 300 /mnt/dockervolumes/data/nexus


##  High-Level Directories Include

    ansible
    doc
    docker


### Environments

  Build  **Please note:  You must your correct container-IP for below:

Jenkins CI Build (http://docker-container-ip:18080/)  
Nexus Artifactory (http://docker-container-ip:18081/nexus/#welcome)  
SE Grid Console (http://docker-container-ip:4444/grid/console)  
SonarQube Dashboard (http://docker-container-ip:19000/)  

### Vars
    group_vars
	  host_vars


### Roles

    roles
         common
              tasks
              handlers
              templates
              files
              vars
              defaults
              meata
              
         webtier
         
         monitoring
    

### Test

## Reference

[Ansible Best Practices Directory Layout] (https://docs.ansible.com/playbooks_best_practices.html#directory-layout "Ansible Best Practices Directory Layout")
