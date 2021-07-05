defmodule Aicacia.Events.Web.Controller.Api.HealthCheck do
  @moduledoc tags: ["Util"]

  use Aicacia.Events.Web, :controller
  use OpenApiSpex.Controller

  alias Aicacia.Events.Web.Schema

  action_fallback Aicacia.Events.Web.Controller.Api.Fallback

  @doc """
  Health Check

  Returns simple json response to see if the server is up and running
  """
  @doc responses: [
         ok: {"Health Check Response", "application/json", Schema.Util.HealthCheck}
       ]
  def health(conn, _params) do
    conn
    |> json(%{ok: true})
  end
end
