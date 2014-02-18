echo "downloading TeamCity"
sudo wget -c http://download.jetbrains.com/teamcity/TeamCity-8.0.6.tar.gz

echo "Untar"
tar -xf TeamCity-8.0.6.tar.gz
chown -R vagrant /opt/TeamCity

sudo wget http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.28/mysql-connector-java-5.1.28.jar
sudo chown -R vagrant mysql-connector-java-5.1.28.jar
sudo chgrp -R vagrant mysql-connector-java-5.1.28.jar

mkdir TeamCity/.BuildServer/lib/jdbc
sudo mv mysql-connector-java-5.1.28.jar TeamCity/.BuildServer/lib/jdbc


echo "modify init.d"
sudo update-rc.d teamcity defaults
/etc/init.d/teamcity start

return 0
