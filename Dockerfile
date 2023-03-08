############################################################
# Dockerfile to build BASIC browser
# Based on Centos
############################################################

# Set the base image to Centos
FROM centos:centos7

# File Author / Maintainer
MAINTAINER Hoang

RUN yum install -y epel-release

RUN yum update -y

RUN yum install -y \ 
	gcc gcc-c++ python2 python2-devel python2-pip python2-virtualenv \
	mercurial git cmake openssl-devel libpng-devel lzo-devel libuuid-devel\
	sqlite-devel zlib-devel bzip2-devel readline-devel \
	gcc-gfortran libgfortran atlas-devel blas-devel lapack-devel \
	httpd mod_wsgi \
	which vim tmux net-tools libtool

#RUN yum install -y boost-devel boost-static

RUN yum clean all

RUN pip install numpy==1.14.2
RUN pip install pandas==0.22.0
RUN pip install cython==0.28.1 
RUN pip install certifi==2018.1.18
RUN pip install numexpr==2.6.4 
RUN pip install bottleneck==1.2.1 
RUN pip install pysam==0.14.1 
RUN pip install bx-python==0.8.1 
RUN pip install simplejson==3.13.2 
RUN pip install anyjson==0.3.3
RUN pip install termcolor==1.1.0
RUN pip install decorator==4.2.1
RUN pip install zipp==1.2.0
RUN pip install configparser==4.0.2
RUN pip install importlib-metadata==1.7.0
RUN pip install bcrypt==3.1.7 
RUN pip install PyNaCl==1.1.2


COPY ./packages/ /BASIC/packages/

RUN (cd /BASIC/packages/fb-pytools/ ; python setup.py install)

RUN pip install -r /BASIC/packages/python_requirements.txt


