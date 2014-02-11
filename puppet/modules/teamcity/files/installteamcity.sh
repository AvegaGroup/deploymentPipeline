echo "downloading TeamCity"
sudo wget -c http://download.jetbrains.com/teamcity/TeamCity-8.0.6.tar.gz

echo "Untar"
tar -xf TeamCity-8.0.6.tar.gz
chown -R vagrant /opt/TeamCity

echo "modify init.d"
sudo update-rc.d teamcity defaults
/etc/init.d/teamcity start

return 0
