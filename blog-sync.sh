# 定义FILES变量
FILES=$(cd /home/yoho/projects/blogs/hugo/content/posts/Notes && git status --porcelain | awk '{print $2}' | paste -sd, -)

# 同步笔记到sirius2alpha/Notes
echo start---同步笔记到sirius2alpha/Notes------------------------
cd /home/yoho/projects/blogs/hugo/content/posts/Notes
git add .
git commit -m "update: $FILES"
git pull
git push
echo end---同步笔记到sirius2alpha/Notes------------------------

# sync dev-hugo branch 
echo start---sync dev-hugo branch------------------------------
cd /home/yoho/projects/blogs/hugo
git add .
git commit -m "update: $FILES"
git pull
git push
echo end---sync dev-hugo branch------------------------------


# build
cd ~/projects/blogs/hugo
hugo

# master branch only push
echo start---master branch-------------------------------------
cd ~/projects/blogs/hugo/public
git add .
git commit -m "feat: $FILES"
git push origin master
echo end---master branch-------------------------------------


# 部署到 Nginx 服务器
NGINX_SERVER_PATH="/var/www/mysites"

# 使用 rsync 同步 public 目录到 Nginx 服务器的相应目录
rsync -av --delete -e "ssh -p 22" ~/projects/blogs/hugo/public/ root@1.94.126.139:$NGINX_SERVER_PATH

# 重启 Nginx 服务
ssh root@1.94.126.139 "sudo systemctl reload nginx"