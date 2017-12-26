#!/bin/bash
git clone https://github.com/Otus-DevOps-2017-11/reddit.git
cd reddit
bundle install
puma -d
if [ "$(ps aux | grep puma | grep -v grep | wc -l)" == "1" ]; then
	echo "true install puma"
else
	echo "false install puma"
fi

sleep 2

if [ "$(curl localhost:9292 | wc -l)" != 0 ]; then
        echo "true reddit work"
else
        echo "false reddit work"
fi
