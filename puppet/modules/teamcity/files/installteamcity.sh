

tar -xf TeamCity-8.0.6.tar.gz
chown -R vagrant /opt/TeamCity

sudo update-rc.d teamcity defaults
/etc/init.d/teamcity start

