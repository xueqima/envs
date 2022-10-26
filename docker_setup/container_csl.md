# csl -> commit & save & load

# container commit 将容器打包为新的镜像
```
docker commit -a <author> -m <commit msg> <容器名称> <新的镜像>
```

# image save 将新的镜像保存为 tar 文件
```
docker save 新保存的镜像名称 > tar文件名称
```

# image load 从 tar 文件中加载镜像
```
docker load < tar文件名称
```