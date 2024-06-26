# https://docs.docker.com/engine/install/ubuntu/

# ===== Install Docker Engine on Ubuntu =====
# Uninstall old versions
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# ===== Install docker =====
## Update the apt package index and install packages to allow apt to use a repository over HTTPS:
sudo proxychains apt-get update

sudo proxychains apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

## Add Docker’s official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
sudo proxychains curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc


# Add the repository to Apt sources:
proxychains echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# delete 'ProxyChains-3.1' info in docker.list
sudo sed -i '1d' /etc/apt/sources.list.d/docker.list


# Install Docker Engine
## Update the apt package index, and install the latest version of Docker Engine, containerd
sudo proxychains apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo docker docker run hello-world


# ===== Installing the NVIDIA Container Toolkit =====

## 這裡我加上了 proxychains ，因為如果不加的話，這些地址 curl 不到 ，注意，当执行完一下命令之后，如果是 20.04，那么最后写入内容为 18.04，而不是 20.04

proxychains curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && proxychains curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# 在 nvidia-container-toolkit.list 文件中删除第一行
sudo sed -i '1d' /etc/apt/sources.list.d/nvidia-container-toolkit.list

# 在 nvidia-container-toolkit.list 文件中找到包含 "experimental" 的行，并将这些行的行首 # 字符（注释符号）删除，从而取消这些行的注释。
sudo sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list

## Install the nvidia-docker2 package (and dependencies) after updating the package listing:
sudo proxychains apt-get update

# 这里在给 yangyue 电脑安装的时候，需要使用 proxy，否则会失败
sudo proxychains apt-get install -y nvidia-container-toolkit

# ===== Configuring Docker =====

# Configure the container runtime by using the nvidia-ctk command:
sudo nvidia-ctk runtime configure --runtime=docker

# Restart the Docker daemon to complete the installation after setting the default runtime:
sudo systemctl restart docker

# At this point, a working setup can be tested by running a base CUDA container:
sudo docker run --rm --gpus all nvidia/cuda:11.0.3-base-ubuntu20.04 nvidia-smi

# set current user to docker group
username=$USER
sudo groupadd docker
sudo usermod -aG docker $username
newgrp docker 
docker ps 

echo "===== postprocessing ====="
echo "=== 
# If u want to manage Docker as a non-root user, u can:
#   sudo groupadd docker
#   sudo usermod -aG docker xueqi
#   newgrp docker 
#   docker ps 
==="

echo "=== 
# if u want clear all the files about docker, you can do like this:
# Uninstall Docker Engine
#   sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-compose-plugin
# However, in general, I do not recommend executing this command!
==="

echo "=== 
# Delete all images, containers, and volumes
#   sudo rm -rf /var/lib/docker
#   sudo rm -rf /var/lib/containerd
# Unless you don't want to live, it is not recommended that you execute the above command!
==="