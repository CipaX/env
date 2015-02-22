subd
====

# General prerequisites

## virtualenv
pip install virtualenv

## virtualenvwrapper
pip install virtualenvwrapper

## LaunchControl for task scheduling
http://www.soma-zone.com/LaunchControl/


# Specific prerequisites

## Make scrapping virtual env
mkvirtualenv scrapping
pip install Scrapy
pip install rarfile

## Add cspy library to the scrapping virtual env
cd ~/env/perhost/Ciprians-iMac.local/cspy
python setup.py develop

## Unrar
brew install unrar


# Schedule task with LaunchControl
- Program to run
	- /Users/ciprian/01-prog/env/tools/env_run/env_run.sh
	- Custom argv: /Users/ciprian/01-prog/env/tools/env_run/env_run.sh subd down watch
- Standard error path
	- /tmp/com.st4n.subd.out
- Standard output path
	- /tmp/com.st4n.subd.err
- Start calendar interval
	- 18:00
