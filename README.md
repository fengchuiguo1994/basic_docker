# basic_docker
Basic browser install and usage

### INSTALL
```
# 关闭seLinux
setenforce 0
修改 /etc/selinux/config 并将 SELINUX=disabled

# 配置环境
yum install deltarpm
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
cd basic_docker/baseimg
docker build .  #可以省略
docker build -t hoang/basic_base .
cd ..
docker-compose build
docker-compose up -d # 启动就可以了。

docker-compose ps # 查看镜像
docker-compose rm # 删除镜像，当之前编译的镜像有错误但又干扰新镜像时使用。
```

### USAGE
上传基因组
```
1. 8008 browser web上点击后台，Organisms添加物种。(human)
2. 点击assembly添加对应物种的不同版本的基因组。(hg38)
3. cp uploadgenome.sh basic_docker && cp split.pl basic_docker && cp build_acgt.new.py BASIC/gis-basic-storage/driver/customds/acgt
4. mkdir genome && mkdir genome/hg38 && mv hg38.fa genome/hg38
5. bash uploadgenome.sh hg38
# 6. 如果有chrband文件，请拷贝至 BASIC/gis-basic-storage/data/genome/chrband/  （hg38.txt，需要命名成和size文件名一致）

7. docker-compose build
8. docker-compose up -d # 启动就可以了。
```

上传数据
```
因为上传的所有文件不能有重名（包括文件夹名），可以参考以下示例批量重命名文件
ls *bw | while read line;do aa=${line/%bw/fengchuiguo.bw};echo mv $line $aa;done

批量产生bed12格式
ls *narrowPeak | while read line;do awk -v OFS="\t" '{print $1,$2,$3,$4,$5,$6,$3,$3,0,1,$3-$2",",0","}' $line | grep -v narrowPeak > $line.bed;done

cd test
python bin/gen_list.py --assembly=hg38 hg38_lung
python bin/bcs_upload.py output.basic.lst --url=http://localhost:8004 --user=browser --force_upload # (user可以指定其它用户)
python bin/upload_list.py output.basic.lst.upload --url=http://localhost:8008 --user=browser
```
