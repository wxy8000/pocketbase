FROM alpine:latest

# 安装必要的依赖
RUN apk add --no-cache wget ca-certificates bash

# 下载 PocketBase
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v0.23.5/pocketbase_0.23.5_linux_amd64.zip -O /tmp/pocketbase.zip \
    && unzip /tmp/pocketbase.zip -d /pocketbase \
    && rm /tmp/pocketbase.zip

# 创建数据和公共目录
RUN mkdir -p /pocketbase/pb_data /pocketbase/pb_public

# 创建启动脚本
RUN echo '#!/bin/bash' > /pocketbase/start.sh && \
    echo 'echo "=== PocketBase Startup ==="' >> /pocketbase/start.sh && \
    echo 'echo "Checking for existing database..."' >> /pocketbase/start.sh && \
    echo 'if [ -f /pocketbase/pb_data/data.db ]; then' >> /pocketbase/start.sh && \
    echo '  echo "Found existing database, removing..."' >> /pocketbase/start.sh && \
    echo '  rm -f /pocketbase/pb_data/data.db' >> /pocketbase/start.sh && \
    echo '  rm -f /pocketbase/pb_data/data.db-shm' >> /pocketbase/start.sh && \
    echo '  rm -f /pocketbase/pb_data/data.db-wal' >> /pocketbase/start.sh && \
    echo 'fi' >> /pocketbase/start.sh && \
    echo 'echo "Database reset complete!"' >> /pocketbase/start.sh && \
    echo 'echo "Starting PocketBase..."' >> /pocketbase/start.sh && \
    echo 'exec /pocketbase/pocketbase serve --http 0.0.0.0:8090' >> /pocketbase/start.sh && \
    chmod +x /pocketbase/start.sh

# 工作目录
WORKDIR /pocketbase

# 暴露端口
EXPOSE 8090

# 使用启动脚本
CMD ["/pocketbase/start.sh"]
