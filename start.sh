#!/bin/bash
# 每个项目请先修改端口
EXPOST_PORT=7000
echo "将回删除原来的容器(名字为文件夹)并启动新的容器,请修改端口.现在为${EXPOST_PORT}"
current_dir=$(dirname $(readlink -f "$0"))
echo "current_dir: ${current_dir}"
base_name=$(basename ${current_dir})
echo "base_name ${base_name}"
commit_id=`git rev-parse --short HEAD`
echo "commit_id: ${commit_id}"
# 编译
echo "编译"
go build -o ./app-exe
echo "go build -o ./app-exe "
# # docker 镜像
echo 构建镜像 && docker build -t ${base_name}:${commit_id} .
# 删除容器 第一次需要手动启动
echo 删除容器 && docker rm -f `docker ps -aq -f name=${base_name} `
# 启动容器
# 挂载日志
echo 启动容器 && docker run -d --restart=always -v ${current_dir}/logs/:/logs/  -p ${EXPOST_PORT}:8080 --name ${base_name} ${base_name}:${commit_id} 
# echo 启动容器 && docker run -d --restart=always -p 7001:8080 --name youke_go youke_go:hand 