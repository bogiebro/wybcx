echo "Url is $DATABASE_URL"
./node_modules/bower/bin/bower install
./node_modules/brunch/bin/brunch build --production
./node_modules/db-migrate/bin/db-migrate up