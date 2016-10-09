use Mix.Config

config :pepe, Pepe.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :extwitter, :oauth, [
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET")
]

config :pepe, Pepe.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  size: 20

