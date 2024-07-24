#!/usr/bin/bash

system_file="/data/work/system_download.txt"

zoo_array=($(cat ${system_file} | grep zookeeper_ip | awk -F '|' '{for(i=2; i<=NF; i++) print $i}'))
len_array=${#zoo_array[@]}

conf_dir=$1
work_dir=$2

file_name=$(find ${conf_dir} -type f -name *zoo.cfg*)
zoo_dir=$(find ${work_dir} -type d -name "*apache-zookeeper-?.?.?*")

# 주키퍼 각 서버 id 값 생성
sed -i '/server.*:2888:3888/d' ${file_name}
for ((i=0; i<len_array; i++));
do
        current_ip=${zoo_array[$i]}
        echo "server.$((i+1))=${current_ip}:2888:3888" >> ${file_name}
	ssh ${current_ip} "ln -s ${zoo_dir} ${work_dir}/zookeeper"
	ssh ${current_ip} "mkdir -p ${zoo_dir}/data"
        ssh ${current_ip} "echo $((i+1)) > ${zoo_dir}/data/myid"
done


# zoo.cfg system_download.txt 참조하여 동적 setup
zoo_config=$(awk '/\[zoo.cfg-start\]/{flag=1; next} /\[zoo.cfg-end\]/{flag=0} flag' ${system_file})
while IFS= read -r zoo_config_low;
do
        zoo_env_name=$(echo $zoo_config_low | awk -F '|' '{print $1}' | sed 's/[][]//g')
        zoo_env_value=$(echo $zoo_config_low | awk -F '|' '{print $2}')
        sed -i "s|^${zoo_env_name}.*$|${zoo_env_name}${zoo_env_value}|" ${file_name}
done <<< $zoo_config


# 동적 setup된 zoo.cfg 각 주키퍼 서버 conf 디렉토리에 배포
zookeeper_conf_dir=$(find ${zoo_dir} -name conf -type d)
for ((j=0; j<len_array; j++));
do
        scp_current_ip=${zoo_array[$j]}
	scp ${file_name} root@${scp_current_ip}:${zookeeper_conf_dir}/qweqwe.cfg
done
