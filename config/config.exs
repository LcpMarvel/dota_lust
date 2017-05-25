# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :dota_lust,
  ecto_repos: [DotaLust.Repo]

# Configures the endpoint
config :dota_lust, DotaLust.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "b2mWTGInSMZyu3VmIqDTnfD3nZoJzuKhXBsLlLFWObJhHTNs3evwanWYTma7MXIm",
  render_errors: [view: DotaLust.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DotaLust.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :dota_lust, wechat_app_id: "wxecaf6b5159ba5151"
config :dota_lust, wechat_secret: "8c2420d85a0228b863b53b35fa571694"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
