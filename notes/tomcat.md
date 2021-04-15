# tomcat部署  
```
  182  ps -ef|grep tomcat
  197  tar xvf apache-tomcat-8.5.54.tar.gz -C /usr/local/
  198  tar xvf jdk-8u172-linux-x64.tar.gz -C /usr/local/
  199  cd  /usr/local/
  200  ln -s apache-tomcat-8.5.54/ tomcat
  202  ln -s jdk1.8.0_172/ java 
  210  echo PATH=$PATH:/usr/local/java/bin >> ~/.bash_profile       
  216  echo CATALINA_HOME=/usr/local/tomcat >> ~/.bash_profile   
  211  source ~/.bash_profile 
  212  echo $PATH
  213  java
  214  java -version
  217  source ~/.bash_profile 
  218  less ~/.bash_profile 
  221  java
  222  java -version
  223  cd tomcat/bin/
  224  ls
  225  ./startup.sh 
  226  echo hello > ../webapps/ROOT/index.jsp 
  227  vi  ../conf/server.xml 
  228  ./shutdown.sh 
  231  ./startup.sh 
  235  vi ../lib/org/apache/catalina/util/ServerInfo.properties
  236  mkdir -pv ../lib/org/apache/catalina/util/
  237  vi ../lib/org/apache/catalina/util/ServerInfo.properties
  238  ./shutdown.sh 
  239  ./startup.sh 
```