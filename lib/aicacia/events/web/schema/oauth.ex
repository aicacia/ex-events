defmodule Aicacia.Events.Web.Schema.Oauth do
  alias OpenApiSpex.Schema

  defmodule Params do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Oauth.Params",
      description: "oauth url params",
      type: :object,
      properties: %{
        response_type: %Schema{type: :string, description: "response type", default: "code"},
        client_id: %Schema{type: :string, description: "client id"},
        redirect_uri: %Schema{type: :string, description: "redirect url"},
        scope: %Schema{type: :string, description: "scope", default: "read"}
      },
      required: [:client_id, :redirect_uri],
      example: %{
        "response_type" => "code",
        "client_id" => "olegruopeugrsjpognls",
        "redirect_uri" => "https://example.com/oauth/callback",
        "scope" => "read"
      }
    })
  end
end
