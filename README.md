# Pepe

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## dokku commands

```
dokku apps:create pepe
dokku postgres:create pepe_postgres
dokku postgres:import pepe_postgres < pepe_db_backup
dokku postgres:link pepe_postgres pepe
dokku config:set pepe BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
dokku config:set pepe LC_ALL=en_US.utf8
dokku config:set pepe SECRET_KEY_BASE="YOUR_SECRET_KEY_BASE"
dokku config:set pepe TWITTER_CONSUMER_KEY="REPLACE_ME" TWITTER_CONSUMER_SECRET="REPLACE_ME"
dokku config:set pepe HOSTNAME=your.host.name
```
