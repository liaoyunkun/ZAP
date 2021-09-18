date=`date`

git status
git pull orgin master
git status
git add *
git status
git commit -am "Autosave $date"
git status
git push origin master
git status

svn status
svn st | grep ^! | awk '{print " --force "$2}' | xargs svn rm
svn status
svn add --force * --auto-props --parents --depth infinity
svn status
svn commit -m "Autosave $date"
svn status


