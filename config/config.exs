use Mix.Config

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    (Mix.env() == "prod" &&
       raise """
       environment variable SECRET_KEY_BASE is missing.
       You can generate one by calling: mix phx.gen.secret
       """)

database_url =
  System.get_env("DATABASE_URL") ||
    (Mix.env() == "prod" &&
       raise """
       environment variable DATABASE_URL is missing.
       """)

config :aicacia_events,
  generators: [binary_id: true],
  ecto_repos: [Aicacia.Events.Repo]

config :aicacia_events, Aicacia.Events.Web.Endpoint,
  url: [host: "localhost"],
  check_origin: false,
  secret_key_base: secret_key_base,
  render_errors: [view: Aicacia.Events.Web.View.Error, accepts: ~w(html json), layout: false],
  pubsub_server: Aicacia.Events.PubSub,
  live_view: [signing_salt: "ozGtcOcL"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :peerage,
  via: Peerage.Via.Dns,
  dns_name: "localhost",
  app_name: "aicacia_events",
  log_results: false,
  interval: 30

config :cors_plug,
  origin: ~r/.*/,
  methods: ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE"]

config :bcrypt_elixir, log_rounds: 12

config :aicacia_events, Aicacia.Events.Repo,
  url: database_url,
  show_sensitive_data_on_connection_error: true

config :aicacia_events, ExOauth2Provider,
  repo: Aicacia.Events.Repo,
  resource_owner: Aicacia.Events.Model.User,
  default_scopes: ~w(read),
  optional_scopes: ~w(write),
  use_refresh_token: true

import_config "#{Mix.env()}.exs"
