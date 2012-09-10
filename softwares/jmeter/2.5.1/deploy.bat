set REPO_URL=http://172.16.18.174:9090/nexus/content/repositories/dev-binaries

call mvn deploy:deploy-file -DgroupId=org.apache.jmeter -DartifactId=jmeter -Dversion=2.5.1 -Dpackaging=zip -Dfile=jakarta-jmeter-2.5.1.zip -DrepositoryId=dev-server -Durl=%REPO_URL%
