date=`date`

git add *
git commit -am "Autosave $date"
git push origin master

svn st | grep ^! | awk '{print " --force "$2}' | xargs svn rm
svn add --force * --auto-props --parents --depth infinity
svn commit -m "Autosave $date"

