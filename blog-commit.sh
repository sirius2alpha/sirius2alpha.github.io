# 定义FILES变量
FILES=$(cd /home/yoho/blog/sirius-blog/content/posts/Notes && git status --porcelain | awk '{print $2}' | paste -sd, -)

# 同步笔记到sirius2alpha/Notes
echo ------------------------start---同步笔记到sirius2alpha/Notes------------------------
cd /home/yoho/blog/sirius-blog/content/posts/Notes
git add .
git commit -m "update: $FILES"
git pull
git push
echo ------------------------end---同步笔记到sirius2alpha/Notes------------------------

# sync dev-hugo branch 
echo ------------------------start---sync dev-hugo branch------------------------------
cd /home/yoho/blog/sirius-blog
git add .
git commit -m "update: $FILES"
git pull
git push
echo ------------------------end---sync dev-hugo branch------------------------------
