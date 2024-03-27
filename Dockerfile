############################################################
# Dockerfile to build BASIC browser
# Based on Centos
############################################################

# Set the base image to Centos
FROM centos:7

# File Author / Maintainer
MAINTAINER Hoang

RUN yum install -y epel-release

RUN yum update -y

RUN yum install -y \ 
	gcc gcc-c++ python python-devel python-pip python-virtualenv deltarpm \
	mercurial git cmake openssl-devel libpng-devel lzo libuuid-devel lzo-devel \
	sqlite-devel zlib-devel bzip2-devel readline-devel \
	gcc-gfortran libgfortran atlas-devel blas-devel lapack-devel \
	httpd mod_wsgi \
	which vim tmux 

#RUN yum install -y boost-devel boost-static

RUN yum clean all

COPY ./packages/ /BASIC/packages/

#RUN pip install numpy-1.14.2-cp27-cp27mu-manylinux1_x86_64.whl
#RUN pip install pandas-0.22.0-cp27-cp27mu-manylinux1_x86_64.whl
#RUN pip install Cython-0.28.1-cp27-cp27mu-manylinux1_x86_64.whl
#RUN pip install numexpr-2.6.4-cp27-cp27mu-manylinux1_x86_64.whl
#RUN pip install Bottleneck-1.2.1.tar.gz
#RUN pip install pysam-0.14.1-cp27-cp27mu-manylinux1_x86_64.whl
#RUN pip install bx-python-0.8.1.tar.gz
#RUN pip install simplejson-3.13.2.tar.gz
RUN pip install numpy==1.14.2 pandas==0.22.0 cython==0.28.1 numexpr==2.6.4 pysam==0.14.1 python-lzo==1.11 bx-python==0.8.1
RUN pip install bottleneck==1.2.1 termcolor==1.1.0 decorator==4.2.1 importlib-metadata==1.7.0 zipp==1.2.0 configparser==4.0.2

RUN (cd /BASIC/packages/fb-pytools/ ; python setup.py install)

# RUN pip install -r /BASIC/packages/python_requirements.txt

RUN pip install amqp==2.2.2 anyjson==0.3.3 asn1crypto==0.24.0 backports.ssl-match-hostname==3.4.0.2 bcrypt==3.1.4 billiard==3.5.0.3 bitarray==0.8.1 celery==4.1.0 certifi==2018.1.18 cffi==1.11.5 chardet==3.0.4 cryptography==2.2.2 Django==1.7.8 django-celery==3.2.2 django-extensions==2.0.6 django-tastypie==0.14.1 enum34==1.1.6 Fabric==1.14.0 futures==3.2.0 gunicorn==19.7.1 idna==2.6 iniparse==0.4 ipaddress==1.0.19 kitchen==1.1.1 kombu==4.1.0 mercurial==2.6.2 networkx==2.1 paramiko==2.4.1 pyasn1==0.4.2 pycparser==2.18 pycurl==7.19.0 pygobject==3.22.0 pygpgme==0.3 pyliblzma==0.5.3 pymongo==3.6.1 PyNaCl==1.2.1 python-dateutil==2.7.2 python-lzo==1.11 python-mimeparse==1.6.0 pytz==2018.3 pyxattr==0.5.1 PyYAML==3.12 requests==2.18.4 simplejson==3.13.2 six==1.11.0 SQLAlchemy==1.2.6 typing==3.6.4 urlgrabber==3.10 urllib3==1.22 vine==1.1.4 yum-metadata-parser==1.1.4 
