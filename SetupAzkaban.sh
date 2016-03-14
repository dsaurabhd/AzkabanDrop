sudo apt-get update 
sudo apt-get install default-jdk git
mkdir ~/opt
mkdir ~/opt/azkaban
cd /opt
git clone https://github.com/vikramkone/azkaban.git
cd azkaban
sudo ./gradlew distTar -x test
tar -xzvf  /opt/azkaban/build/distributions/azkaban-web-server-3.0.0.tar.gz -C /opt/azkaban/
tar -xzvf  /opt/azkaban/build/distributions/azkaban-exec-server-3.0.0.tar.gz -C /opt/azkaban/ 
tar -xzvf  /opt/azkaban/build/distributions/azkaban-sql-3.0.0.tar.gz -C /opt/azkaban/


# Try this
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -q -y install mysql-server
# Of course, it leaves you with a blank root password - so you'll want to run something like
# http://stackoverflow.com/questions/7739645/install-mysql-on-ubuntu-without-password-prompt
mysqladmin -u root password azkaban


mkdir ~/tmp
cd ~/tmp

#Download the .SQL file to create user and database
wget https://raw.githubusercontent.com/dsaurabhd/AzkabanDrop/master/AzkabanSetupcreateDbUser.sql
wget https://raw.githubusercontent.com/dsaurabhd/AzkabanDrop/master/hacked-azkaban-executor-start.sh
wget https://raw.githubusercontent.com/dsaurabhd/AzkabanDrop/master/hacked-azkaban-web-start.sh
wget https://raw.githubusercontent.com/dsaurabhd/AzkabanDrop/master/hacked-web-server-azkaban.properties


# For the SQL commands, create a .sql file
mysql -u root -pazkaban < AzkabanSetupcreateDbUser.sql
mysql azkaban -u root -pazkaban  < /opt/azkaban/azkaban-sql-3.0.0/create-all-sql-3.0.0.sql 
mysql azkaban -u root -pazkaban  < /opt/azkaban/azkaban-sql-3.0.0/update.active_executing_flows.3.0.sql 
mysql azkaban -u root -pazkaban  < /opt/azkaban/azkaban-sql-3.0.0/update.execution_flows.3.0.sql

wget -q https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz -P /opt/azkaban/azkaban-web-server-3.0.0/extlib/ 
wget -q https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz -P /opt/azkaban/azkaban-exec-server-3.0.0/extlib/ 
 
#Update the startup scripts to run the web and exec processes is the background 
mkdir -p /opt/azkaban/azkaban-web-server-3.0.0/logs

mv ~/tmp/hacked-azkaban-web-start.sh /opt/azkaban/azkaban-web-server-3.0.0/bin/azkaban-web-start.sh
mv ~/tmp/hacked-azkaban-web-start.sh /opt/azkaban/azkaban-exec-server-3.0.0/bin/azkaban-executor-start.sh
mv ~/tmp/hacked-web-server-azkaban.properties /opt/azkaban/azkaban-web-server-3.0.0/conf/azkaban.properties file

#HAck the following files and you are done
#vi azkaban-web-server-3.0.0/bin/azkaban-web-start.sh 
#vi azkaban-exec-server-3.0.0/bin/azkaban-executor-start.sh
#/opt/azkaban/azkaban-web-server-3.0.0/conf/azkaban.properties file




