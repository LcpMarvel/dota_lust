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

dota2_api_keys = ["93D942144C4B978E9BE9EF157693B642", "D13FA9671981D4C4179596F041EC4DDD"]
config :dota2_api, keys: dota2_api_keys

config :exq,
  name: Exq,
  host: "127.0.0.1",
  port: 6379,
  password: nil,
  namespace: "dotalust_dev",
  queues: [{"default", :infinite}, {"dota2_api", Enum.count(dota2_api_keys)}],
  poll_timeout: 50,
  scheduler_poll_timeout: 200,
  scheduler_enable: true,
  max_retries: 2,
  shutdown_timeout: 5000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
