# 创建新的虚拟服务器, <username>.c 只是一个容器的名字，表示该容器是 <username> 的 [c]ontainer, 创建
sudo docker run -d --name <username>.c --gpus all --hostname <username>-<ip末段> --shm-size 32g -p 12222:22 -p 14000:3389 -p 15000:15000 -v /mnt/d/<hostname>:/mnt/d danielguerra/ubuntu-xrdp:20.04
