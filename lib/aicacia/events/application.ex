defmodule Aicacia.Events.Application do
  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = [
      Aicacia.Events.Repo,
      Aicacia.Events.Web.Telemetry,
      {Phoenix.PubSub, name: Aicacia.Events.PubSub},
      Aicacia.Events.Web.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Aicacia.Events.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Aicacia.Events.Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
