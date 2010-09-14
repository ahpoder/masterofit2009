//20100906/PMD:
Based on 
http://localhost:8080/docs/appdev/processes.html

Create a build.properties file next to the build.xml file with the following content:
---
# Tomcat 6 installation directory (relative to the current folder)
catalina.home=../../../../Program Files/Apache Software Foundation/Tomcat 6.0

# Manager webapp username and password (tomcat manager)
manager.username=
manager.password=
---End-of-build.properties---

Install ant and copy the file "lib/catalina-ant.jar" from your Tomcat 6
installation into the "lib" directory of your Ant installation.

Use ant for build. 
The following commands may be issued from a shell window set to the project root directory.

ant with nothing on the command line will run the default compile target
ant all: recompiles everything
ant install: installs the application in a running tomcat. The tomcat context path is defined by app.path in build.xml
ant reload: trigger a tomcat reload of servlet(s)
ant remove: remove the application from tomcat
ant dist: create a distributable web application archive (WAR) file
ant clean: remove all files created by the build process


