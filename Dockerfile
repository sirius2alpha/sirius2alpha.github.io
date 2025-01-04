FROM hugomods/hugo:std-go-0.127.0

# 设置工作目录
WORKDIR /app

# 复制项目文件到工作目录
COPY . .

# 构建 Hugo 静态网站
RUN hugo --minify

# 使用 Nginx 作为 Web 服务器
FROM nginx:alpine

# 复制生成的静态文件到 Nginx 的默认目录
COPY --from=0 /app/public /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]