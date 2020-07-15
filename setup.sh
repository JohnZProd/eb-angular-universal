curl -O https://angular.io/generated/zips/universal/universal.zip 

unzip universal.zip -d universal/
rm -f universal.zip
mv build.sh universal/
mv .ebextensions/ universal/
cd universal/
