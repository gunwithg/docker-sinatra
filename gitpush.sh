#go to home and setup git  
cd $HOME
git config --global user.email "Iamtravis@travis.com"
git config --global user.name "Iam Travis" 
#clone the repository in the buildApk folder
git clone --branch=master  https://gunwithg:$GITHUB_API_KEY@github.com/gunwithg/docker-sinatra  master > /dev/null
#go into directory and copy data we're interested
cd master  
ls -alih
cat .git/config
#add, commit and push files
#git remote add origin https://gunwithg:$GITHUB_API_KEY@github.com/gunwithg/docker-sinatra.git
touch projectname.hcl
echo "${TRAVIS_BUILD_NUMBER}" > projectname.hcl
git add -f .
git remote rm origin
git remote add origin https://gunwithg:$GITHUB_API_KEY@github.com/gunwithg/docker-sinatra.git
cat .git/config
git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed [skip ci] "
git push -fq origin master:deploy 
echo -e "Done\n"
