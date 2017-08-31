FROM jenkins:2.60.2-alpine
MAINTAINER Andrew Wu andrew.wu@thinkbiganalytics.com

# Install Jenkins Plugins
COPY resources/plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

# Configure Maven installation location in Jenkins
COPY resources/hudson.tasks.Maven.xml /var/jenkins_home/hudson.tasks.Maven.xml

# Copy Docker config
COPY resources/org.jenkinsci.plugins.docker.commons.tools.DockerTool.xml /var/jenkins_home/org.jenkinsci.plugins.docker.commons.tools.DockerTool.xml

# Install maven
USER root
RUN   apk update \
  &&   apk add ca-certificates wget \
  &&   update-ca-certificates
# get maven 3.5.0
RUN wget --no-verbose -O /tmp/apache-maven-3.5.0.tar.gz http://archive.apache.org/dist/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz

# verify checksum
RUN echo "35c39251d2af99b6624d40d801f6ff02 /tmp/apache-maven-3.5.0.tar.gz" | md5sum -c
RUN mkdir /opt
# install maven
RUN tar xzf /tmp/apache-maven-3.5.0.tar.gz -C /opt/
RUN ln -s /opt/apache-maven-3.5.0 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.5.0.tar.gz
ENV MAVEN_HOME /opt/maven

# Switch back to Jenkins user
USER jenkins