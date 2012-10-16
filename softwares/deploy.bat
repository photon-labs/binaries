set REPO_ID=dev-releases
set REPO_URL=http://localhost:9090/nexus/content/repositories/releases/

echo

                         **********DEPLOYING JMETER-2.5.1 **********
call mvn deploy:deploy-file -DgroupId=org.apache.jmeter -DartifactId=jmeter -Dversion=2.5.1 -Dpackaging=zip -Dfile=..\softwares\jmeter\2.5.1\jakarta-jmeter-2.5.1.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=binaries -DartifactId=apache-tomcat -Dversion=7.0.21 -Dpackaging=zip -Dfile=..\softwares\tomcat\apache-tomcat-7.0.21.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=binaries -DartifactId=apache-tomcat-https -Dversion=7.0.21 -Dpackaging=zip -Dfile=..\softwares\tomcat\apache-tomcat-https\apache-tomcat-https-7.0.21.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=sonar -DartifactId=sonar -Dversion=3.1.1 -Dpackaging=war -Dfile=..\softwares\sonar\3.1.1\sonar-3.1.1\war\sonar.war -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=sonar -DartifactId=sonar -Dversion=3.1.1 -Dpackaging=zip -Dfile=..\softwares\sonar\3.1.1\sonar-3.1.1\zip\sonar-3.1.1.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=softwares.iphone.files -DartifactId=waxsim -Dversion=1.0 -Dclassifier=mac -Dpackaging=zip -Dfile=..\softwares\waxsim\waxsim-mac\waxsim-1.0-mac.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=softwares.iphone.files -DartifactId=waxsim -Dversion=1.0 -Dclassifier=windows -Dpackaging=zip -Dfile=..\softwares\waxsim\waxsim-winx\waxsim-1.0-windows.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=softwares.iphone.files -DartifactId=checker-269 -Dversion=0.1 -Dclassifier=mac -Dpackaging=zip -Dfile=..\softwares\checker\checker-mac\checker-269-0.1-mac.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=softwares.iphone.files -DartifactId=checker-269 -Dversion=0.1 -Dclassifier=windows -Dpackaging=zip -Dfile=..\softwares\checker\checker-winx\checker-269-0.1-windows.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=softwares.iphone.files -DartifactId=device-deploy -Dversion=1.0 -Dclassifier=mac -Dpackaging=zip -Dfile=..\softwares\chief\chief-mac\device-deploy-1.0-mac.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=softwares.iphone.files -DartifactId=device-deploy -Dversion=1.0 -Dclassifier=windows -Dpackaging=zip -Dfile=..\softwares\chief\chief-winx\device-deploy-1.0-windows.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=binaries -DartifactId=phantomjs -Dversion=1.5.0 -Dclassifier=linux-x64 -Dpackaging=tar.gz -Dfile=..\softwares\phantomjs\phantomjs-linux-x64\phantomjs-1.5.0-linux-x64.tar.gz -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=binaries -DartifactId=phantomjs -Dversion=1.5.0 -Dclassifier=linux-x86 -Dpackaging=zip -Dfile=..\softwares\phantomjs\phantomjs-linux-x86\phantomjs-1.5.0-linux-x86.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=binaries -DartifactId=phantomjs -Dversion=1.5.0 -Dclassifier=mac -Dpackaging=zip -Dfile=..\softwares\phantomjs\phantomjs-mac\phantomjs-1.5.0-mac.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%

call mvn deploy:deploy-file -DgroupId=binaries -DartifactId=phantomjs -Dversion=1.5.0 -Dclassifier=windows -Dpackaging=zip -Dfile=..\softwares\phantomjs\phantomjs-winx\phantomjs-1.5.0-windows.zip -DrepositoryId=%REPO_ID% -Durl=%REPO_URL%



