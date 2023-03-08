# basic_docker
Basic browser install and usage

### INSTALL
```
# 关闭seLinux
setenforce 0
修改 /etc/selinux/config 并将 SELINUX=disabled

# 配置环境
yum install docker httpd libcgroup libcgroup-tools
systemctl start docker.service
systemctl enable docker.service
# docker run hello-world # 测试
systemctl start httpd.service
systemctl enable httpd.service
cgcreate -g memory,cpu,blkio,cpuset:userlimited
cgconfigparser -l /etc/cgconfig.conf
systemctl start cgconfig.service
systemctl enable cgconfig.service

wget https://repo.anaconda.com/miniconda/Miniconda2-py27_4.8.3-Linux-x86_64.sh
bash Miniconda2-py27_4.8.3-Linux-x86_64.sh # 默认安装
pip install docker-compose

# 安装BASIC
tar zxf basic_docker.tar.gz
cp Dockerfile basic_docker/baseimg
cp python_requirements.txt basic_docker/baseimg/packages
cd basic_docker/baseimg
docker build .  #可以省略
docker build -t hoang/basic_base .
cd ..
docker-compose build
docker-compose up -d
```