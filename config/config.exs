# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pepe,
  ecto_repos: [Pepe.Repo]

# Configures the endpoint
config :pepe, Pepe.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vZMxrbDPS+/HAh6ULzncvyG6ryyaKdWngP7rhLKJEibNZEiWa+0C2IPxxob3aYk5",
  render_errors: [view: Pepe.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Pepe.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# This line was automatically added by ansible-elixir-stack setup script
if System.get_env("SERVER") do
  config :phoenix, :serve_endpoints, true
end
