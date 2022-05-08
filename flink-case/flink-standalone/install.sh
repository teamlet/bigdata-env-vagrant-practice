#!/bin/bash

cp /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list

sudo apt-get update
sudo apt-get install default-jre -y
sudo apt-get install default-jdk unzip -y
sudo apt-get clean

echo -e "\n  \033[40;32m *** Installing Apache flink ... \033[0m\n"

wget https://archive.apache.org/dist/flink/flink-1.14.4/flink-1.14.4-bin-scala_2.12.tgz

tar xzvf flink-1.14.4-bin-scala_2.12.tgz

ln -s flink-1.14.4 flink

cd flink

cat << EOF >> words.txt
hadoop hadoop hadoop
spark spark spark
flink flink flink
EOF

echo -e "\n  \033[40;32m *** Starting Apache flink ... \033[0m\n"


./bin/start-cluster.sh

echo -e "\n  \033[40;32m *** Checking Apache flink ... \033[0m\n"

jps

echo -e "\n  \033[40;32m *** Testing Apache flink ... \033[0m\n"


./bin/flink run examples/batch/WordCount.jar --input /home/vagrant/flink/words.txt --output /home/vagrant/flink/output-result

echo -e "\n  \033[40;32m *** Stoping Apache flink ... \033[0m\n"

./bin/stop-cluster.sh


echo -e "\n  \033[40;32m *** Checking Apache flink result ... \033[0m\n"

cat output-result
