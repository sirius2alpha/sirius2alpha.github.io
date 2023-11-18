# 定义FILES变量
FILES=$(cd /home/yoho/projects/blogs/hugo/content/posts/Notes && git status --porcelain | awk '{print $2}' | paste -sd, -)

# 同步笔记到Notes仓库
cd /home/yoho/projects/blogs/hugo/content/posts/Notes
git add .
git commit -m "update: $FILES" # 自动列出更改的文件
git push

# 发布到博客
cd ~/projects/blogs/hugo
hugo

# 切换到博客仓库根目录
cd ~/projects/blogs/hugo/public
git add .
git commit -m "feat: $FILES" 
git push origin master

