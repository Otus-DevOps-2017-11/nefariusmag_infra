#!/bin/bash
user=reddit
useradd ${user}
mkdir /home/${user}
chown -R ${user}:${user} /home/${user}
cd /home/${user}

apt update -y
apt install -y ruby-full ruby-bundler build-essential
if [ "$(ruby -v)" == 'ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]' ]; then 
	echo "true install ruby" > install.log
else 
	echo "false install ruby" > install.log
fi
if [ "$(bundle -v)" == 'Bundler version 1.11.2' ]; then
        echo "true install bundler" >> install.log
else
        echo "false install bundler" >> install.log
fi

sleep 2

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
apt update -y
apt install -y mongodb-org
systemctl start mongod
systemctl enable mongod
if [ "$(systemctl status mongod | wc -l)" == "9" ]; then
	echo "true install & start mongod" >> install.log
else
	echo "false install & start mongod" >> install.log
	echo "systemctl status mongod | wc -l = $(systemctl status mongod | wc -l)" >> install.sh
fi

sleep 2

git clone https://github.com/Otus-DevOps-2017-11/reddit.git
cd reddit && bundle install
bundle install
su -l ${user} -c "puma -d"
if [ "$(ps aux | grep puma | grep -v grep | wc -l)" == "1" ]; then
	echo "true install puma" >> install.log
else
	echo "false install puma" >> install.log
fi
