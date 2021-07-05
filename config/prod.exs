use Mix.Config

config :aicacia_events, Aicacia.Events.Web.Endpoint, http: [port: 4000]

config :logger, level: :info

config :peerage,
  via: Peerage.Via.Dns,
  dns_name: "id-aicacia-events.api"

config :aicacia_events, Aicacia.Events.Repo,
  show_sensitive_data_on_connection_error: false,
  pool_size: 30
