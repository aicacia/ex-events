defmodule Aicacia.Events.Web.ApiSpec do
  @behaviour OpenApiSpex.OpenApi

  @impl OpenApiSpex.OpenApi
  def spec,
    do:
      %OpenApiSpex.OpenApi{
        servers: [
          OpenApiSpex.Server.from_endpoint(Aicacia.Events.Web.Endpoint),
          "https://api.events.aicacia.com"
        ],
        info: %OpenApiSpex.Info{
          title: Application.spec(:aicacia_events, :description) |> to_string(),
          version: Application.spec(:aicacia_events, :vsn) |> to_string()
        },
        paths: OpenApiSpex.Paths.from_router(Aicacia.Events.Web.Router),
        components: %OpenApiSpex.Components{
          securitySchemes: %{
            "authorization" => %OpenApiSpex.SecurityScheme{type: "http", scheme: "bearer"}
          }
        }
      }
      |> OpenApiSpex.resolve_schema_modules()
end
