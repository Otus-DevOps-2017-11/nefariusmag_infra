#!/bin/bash
sudo apt update -y
sudo apt install -y ruby-full ruby-bundler build-essential
if [ "$(ruby -v)" == 'ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]' ]; then 
	echo "true install ruby"
else 
	echo "false install ruby" 
fi
if [ "$(bundle -v)" == 'Bundler version 1.11.2' ]; then
        echo "true install bundler"
else
        echo "false install bundler"
fi
