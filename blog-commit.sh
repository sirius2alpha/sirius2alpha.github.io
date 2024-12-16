# load BLOG_HOME
source config.sh

FILES=$(cd $BLOG_HOME/content/posts/Notes && git status --porcelain | awk '{print $2}' | paste -sd, -)

# sync notes to sirius2alpha/Notes
echo ------------------------start---同步笔记到sirius2alpha/Notes------------------------
cd $BLOG_HOME/content/posts/Notes
git add .
git commit -m "update: $FILES"
git pull
git push
echo ------------------------end---同步笔记到sirius2alpha/Notes------------------------

# sync master branch
echo ------------------------start---sync master branch------------------------------
cd $BLOG_HOME
git add .
git commit -m "update: $FILES"
git pull
git push
echo ------------------------end---sync master branch------------------------------