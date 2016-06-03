git pull origin master
mix deps.get --only prod
MIX_ENV=prod mix compile
./node_modules/.bin/brunch build --production
MIX_ENV=prod mix phoenix.digest
MIX_ENV=prod mix ecto.migrate
