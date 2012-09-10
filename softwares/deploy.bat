set REPO_ID=dev-releases
set REPO_URL=http://localhost:9090/nexus/content/repositories/releases/

echo

                         **********DEPLOYING JMETER-2.5.1 **********
call mvn deploy:deploy-file -DgroupId=org.apache.jmeter -DartifactId=jmeter -Dversion=2.5.1 -Dpackaging=zip -Dfile=..\softwares\jmeter\2.5.1\jakarta-jmeter-2.5.1.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=binaries -DartifactId=apache-tomcat -Dversion=7.0.21 -Dpackaging=zip -Dfile=..\softwares\tomcat\apache-tomcat-7.0.21.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=binaries -DartifactId=apache-tomcat-https -Dversion=7.0.21 -Dpackaging=zip -Dfile=..\softwares\tomcat\apache-tomcat-https\apache-tomcat-https-7.0.21.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=sonar -DartifactId=sonar -Dversion=3.1.1 -Dpackaging=war -Dfile=..\softwares\sonar\3.1.1\sonar-3.1.1\war\sonar.war -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

