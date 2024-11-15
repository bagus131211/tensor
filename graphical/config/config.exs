# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :graphical,
  ecto_repos: [Graphical.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :graphical, GraphicalWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: GraphicalWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Graphical.PubSub,
  live_view: [signing_salt: "hpKYCCov"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :graphical, Graphical.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :graphical, Graphical.Guardian,
  issuer: "graphical",
  secret_key: "PWkd7rPoieDY7+zQz7YHvv/ewLNY70caLDB+7x107nOqoQmDLf1gdTz0bFWceLM7"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
