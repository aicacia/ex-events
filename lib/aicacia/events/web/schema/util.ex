defmodule Aicacia.Events.Web.Schema.Util do
  alias OpenApiSpex.Schema

  defmodule HealthCheck do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Util.HealthCheck",
      description: "health check",
      type: :object,
      properties: %{
        ok: %Schema{type: :boolean, description: "ok status"}
      },
      required: [:ok],
      example: %{
        "ok" => true
      }
    })
  end
end
