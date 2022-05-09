#!/bin/bash

cp /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list

sudo apt-get update
sudo apt-get install default-jre -y
sudo apt-get install default-jdk unzip -y
sudo apt-get clean

echo -e "\n  \033[40;32m *** Installing Apache zookeeper... \033[0m\n"

wget https://dlcdn.apache.org/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0-bin.tar.gz

tar xzvf apache-zookeeper-3.8.0-bin.tar.gz

ln -s apache-zookeeper-3.8.0-bin zookeeper

rm apache-zookeeper-3.8.0-bin.tar.gz

cd zookeeper

echo -e "\n  \033[40;32m *** Config Apache zookeeper... \033[0m\n"

mkdir data 

cat << EOF >> data/myid
$2
EOF

cp conf/zoo_sample.cfg conf/zoo.cfg 

sudo sed "s/^dataDir=.*/dataDir=\/home\/vagrant\/zookeeper\/data/g" -i conf/zoo.cfg
echo  server.1=$11:2888:3888 >> conf/zoo.cfg
echo  server.2=$12:2888:3888 >> conf/zoo.cfg
echo  server.3=$13:2888:3888 >> conf/zoo.cfg

echo -e "\n  \033[40;32m *** Starting Apache zookeeper... \033[0m\n"

./bin/zkServer.sh start
sleep 3
echo -e "\n  \033[40;32m *** Checking Apache zookeeper... \033[0m\n"

./bin/zkServer.sh status

echo -e "\n  \033[40;32m *** DONE. \033[0m\n"
