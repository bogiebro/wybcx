rm -r build
./node_modules/bower/bin/bower install
./node_modules/brunch/bin/brunch build --production
find build -type f | grep 'js\|css\|png' | ./node_modules/LiveScript/bin/livescript s3upload.ls