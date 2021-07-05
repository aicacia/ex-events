defmodule Aicacia.Events.Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :aicacia_events

  @session_options [
    store: :cookie,
    key: "_aicacia_events_key",
    signing_salt: "R3mi5EoH"
  ]

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  socket "/socket", Aicacia.Events.Web.Socket.User,
    websocket: true,
    longpoll: false

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug CORSPlug

  plug Aicacia.Events.Web.Router
end
