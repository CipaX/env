photorg
=======

## Description

Photo organization tool  

It basically uses exif data to rename photos as
<date>_<time>-<make>-<model>.<ext> (e.g. 2015-01-25_21.59.49-Apple-iPhone_6.jpg).  

At the same time, it separates them in per-month folders named as <yyyy><mm> (e.g. 2015.02).  


# General prerequisites

## virtualenv
pip install virtualenv  

## virtualenvwrapper
pip install virtualenvwrapper  


# Specific prerequisites

## exiftool

http://www.sno.phy.queensu.ca/~phil/exiftool/install.html  

## Make photo organization virtual env  
mkvirtualenv photo_org  

## Add cspy library to the scrapping virtual env
cd ~/env/perhost/Ciprians-iMac.local/tools/cspy  
python setup.py develop  

## exiftool python wrapper  

Download tarball from:  
http://smarnach.github.io/pyexiftool/  
  
With photo_org virtual env active, from the extracted tarball dir:  
python setup.py build  
python setup.py install  
