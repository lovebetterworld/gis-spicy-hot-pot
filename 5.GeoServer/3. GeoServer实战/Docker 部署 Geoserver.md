- [Docker 部署 Geoserver](https://blog.csdn.net/u010206379/article/details/109764629)

默认账号密码：

```json
Username: admin
Password: geoserver
```

DockerHub：

> https://registry.hub.docker.com/r/kartoza/geoserver

## 一、Docker 部署 Geoserver

### 1.1 参考镜像

[kartoza/docker-geoserver](https://github.com/kartoza/docker-geoserver)

### 1.2 获取镜像

```
# 获取镜像
docker pull kartoza/geoserver
```

启动Geoserver并访问

### 1.3 启动容器/查看容器/杀死容器

```bash
# 启动容器
docker run -d -p 8080:8080 --name geoserver kartoza/geoserver:2.16.2

# 查看容器
docker container ls

# 杀死容器
docker kill container-id

# 删除该容器
docker rm container-id
```

### 1.4 后台运行

```bash
nohup docker run -d -p 8080:8080 --name geoserver kartoza/geoserver:2.16.2
```

### 1.5 指定挂载路径并启动

> 需要-e 指定用户名和密码

```bash
# 将主机的/data/geoserver_data挂载到容器的/etc/letsencrypt下
docker run -d -v /var/minio/geoserver:/etc/letsencrypt -p 8090:8080 --name geoserver kartoza/geoserver
```

### 1.6 更新image(见上文备注中的注意事项)

    添加工作区
    更新image

```bash
# 更新image
docker commit -m 'add workspace fromglc' -a 'your_name' container-id kartoza/geoserver:your_tag

# 查看镜像
docker image ls

# 删除镜像
docker rmi image_id
```

