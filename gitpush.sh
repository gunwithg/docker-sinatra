#go to home and setup git  
cd $HOME
git config --global user.email "Iamtravis@travis.com"
git config --global user.name "Iam Travis" 
#clone the repository in the buildApk folder
git clone --quiet --branch=master  https://gunwithg:$GITHUB_API_KEY@github.com/gunwithg/docker-sinatra  master > /dev/null
#go into directory and copy data we're interested
cd master  
#add, commit and push files
git add -f .
touch projectname.hcl
echo "${TRAVIS_BUILD_NUMBER}" > projectname.hcl
git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed [skip ci] "
git push -fq origin deploy > /dev/null
echo -e "Done\n"
