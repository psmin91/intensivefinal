# Centos based container with Java and Tomcat 
FROM centos:centos7 
MAINTAINER Karthik 
 
# Install prepare infrastructure 
RUN yum -y update && \ 
 yum -y install wget && \ 
 yum -y install tar 
 
# Prepare environment  
ENV JAVA_HOME /usr 
ENV CATALINA_HOME /opt/tomcat  
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts 
 
# Install Oracle Java8 
RUN yum -y install java 
RUN java -version 
 
# Install Tomcat 
RUN wget http://mirror.linux-ia64.org/apache/tomcat/tomcat-7/v7.0.96/bin/apache-tomcat-7.0.96.tar.gz && \ 
 tar -xvf apache-tomcat-7.0.96.tar.gz && \ 
 rm apache-tomcat*.tar.gz && \ 
 mv apache-tomcat* ${CATALINA_HOME} 
 
RUN chmod +x ${CATALINA_HOME}/bin/*sh 
 
# Create Tomcat admin user 
COPY ./docker/create_admin_user.sh $CATALINA_HOME/scripts/create_admin_user.sh 
COPY ./docker/tomcat.sh $CATALINA_HOME/scripts/tomcat.sh 
RUN chmod +x $CATALINA_HOME/scripts/*.sh 
 
# Create tomcat user 
RUN groupadd -r tomcat && \ 
 useradd -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin  -c "Tomcat user" tomcat && \ 
 chown -R tomcat:tomcat ${CATALINA_HOME} 
 
WORKDIR /opt/tomcat 
 
RUN mkdir -p /var/docker/tomcat-sample 
COPY ./docker/env.properties /var/docker/tomcat-sample/env.properties 
RUN rm -r /opt/tomcat/webapps/ROOT 
COPY ./target/javawebdemo.war /opt/tomcat/webapps/ROOT.war 
 
EXPOSE 8080 
 
USER tomcat 
CMD ["tomcat.sh"] 