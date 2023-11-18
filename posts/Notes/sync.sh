# 同步笔记到Notes仓库
cd /home/yoho/projects/blogs/hugo/content/posts/Notes
git add .
git commit -m "update: $(git status --porcelain | awk '{print $2}' | paste -sd, -)" # 自动列出更改的文件
git push

# 发布到博客
cd ~/projects/blogs/hugo
hugo

# 切换到博客仓库根目录（如果hugo/public不是仓库根目录的话）
cd ~/projects/blogs/hugo/public # 添加您的博客仓库的路径
git add .
git commit -m "feat: $(git status --porcelain | awk '{print $2}' | paste -sd, -)" # 自动列出更改的博文
git push origin master

