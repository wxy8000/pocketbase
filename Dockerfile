FROM alpine:latest

# 安装必要的依赖
RUN apk add --no-cache wget ca-certificates

# 下载 PocketBase
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v0.23.5/pocketbase_0.23.5_linux_amd64.zip -O /tmp/pocketbase.zip \
    && unzip /tmp/pocketbase.zip -d /pocketbase \
    && rm /tmp/pocketbase.zip

# 创建数据和公共目录
RUN mkdir -p /pocketbase/pb_data /pocketbase/pb_public

# 工作目录
WORKDIR /pocketbase

# 暴露端口
EXPOSE 8090

# 启动脚本 - 重置数据库并启动
CMD echo "Resetting PocketBase database..." && \
    rm -rf /pocketbase/pb_data/* && \
    echo "Database reset complete. Starting PocketBase..." && \
    ./pocketbase serve --http 0.0.0.0:8090
