defmodule Aicacia.Events.Web.Controller.Api.Oauth do
  @moduledoc tags: ["User"]

  use Aicacia.Events.Web, :controller
  use OpenApiSpex.Controller

  action_fallback(Aicacia.Events.Web.Controller.Api.Fallback)

  @doc """
  preauthorize a user
  """
  @doc parameters: [
         response_type: [
           in: :query,
           type: :string,
           required: true,
           description: "response type",
           example: "code"
         ],
         client_id: [
           in: :query,
           type: :string,
           required: true,
           description: "client application id",
           example: "45sdfdsgse53gsdhheths"
         ],
         redirect_uri: [
           in: :query,
           type: :string,
           required: true,
           description: "redirect uri",
           example: "https://example.com/oauth/callback"
         ],
         scope: [
           in: :query,
           type: :string,
           required: true,
           description: "scope",
           example: "read"
         ]
       ]
  def preauthorize(conn, params) do
    resource_owner = ExOauth2Provider.Plug.current_resource_owner(conn)

    case ExOauth2Provider.Authorization.preauthorize(resource_owner, params,
           otp_app: :aicacia_events
         ) do
      {:ok, client, scopes} ->
        conn
        |> json(%{
          client: %{
            id: client.id,
            name: client.name,
            owner_id: client.owner_id,
            redirect_uri: client.redirect_uri,
            scopes: client.scopes,
            client_id: client.uid,
            client_secret: client.secret,
            inserted_at: client.inserted_at,
            updated_at: client.updated_at
          },
          scopes: scopes
        })

      {:redirect, redirect_uri} ->
        redirect(conn, external: redirect_uri)

      {:native_redirect, %{code: code}} ->
        json(conn, %{code: code})
    end
  end

  @doc """
  authorize a user
  """
  @doc parameters: [
         response_type: [
           in: :query,
           type: :string,
           required: true,
           description: "response type",
           example: "code"
         ],
         client_id: [
           in: :query,
           type: :string,
           required: true,
           description: "client application id",
           example: "45sdfdsgse53gsdhheths"
         ],
         redirect_uri: [
           in: :query,
           type: :string,
           required: true,
           description: "redirect uri",
           example: "https://example.com/oauth/callback"
         ],
         scope: [
           in: :query,
           type: :string,
           required: true,
           description: "scope",
           example: "read"
         ]
       ]
  def authorize(conn, params) do
    resource_owner = ExOauth2Provider.Plug.current_resource_owner(conn)

    case ExOauth2Provider.Authorization.authorize(resource_owner, params, otp_app: :aicacia_events) do
      {:redirect, redirect_uri} ->
        redirect(conn, external: redirect_uri)

      {:native_redirect, %{code: code}} ->
        json(conn, %{code: code})
    end
  end

  @doc """
  deny a user
  """
  @doc parameters: [
         response_type: [
           in: :query,
           type: :string,
           required: true,
           description: "response type",
           example: "code"
         ],
         client_id: [
           in: :query,
           type: :string,
           required: true,
           description: "client application id",
           example: "45sdfdsgse53gsdhheths"
         ],
         redirect_uri: [
           in: :query,
           type: :string,
           required: true,
           description: "redirect uri",
           example: "https://example.com/oauth/callback"
         ],
         scope: [
           in: :query,
           type: :string,
           required: true,
           description: "scope",
           example: "read"
         ]
       ]
  def deny(conn, params) do
    resource_owner = ExOauth2Provider.Plug.current_resource_owner(conn)

    with {:redirect, redirect_uri} <-
           ExOauth2Provider.Authorization.deny(resource_owner, params, otp_app: :aicacia_events) do
      redirect(conn, external: redirect_uri)
    end
  end

  @doc """
  token grant
  """
  @doc parameters: [
         client_id: [
           in: :query,
           type: :string,
           required: true,
           description: "client application id",
           example: "45sdfdsgse53gsdhheths"
         ],
         client_secret: [
           in: :query,
           type: :string,
           required: true,
           description: "client application secret",
           example: "9ppwrfhep9nfwpojfn4s"
         ],
         grant_type: [
           in: :query,
           type: :string,
           required: true,
           description: "response type",
           example: "code"
         ],
         code: [
           in: :query,
           type: :string,
           required: true,
           description: "code",
           example: 123_456
         ],
         redirect_uri: [
           in: :query,
           type: :string,
           required: true,
           description: "redirect uri",
           example: "https://example.com/oauth/callback"
         ]
       ]
  def token_grant(conn, params) do
    with {:ok, access_token} <- ExOauth2Provider.Token.grant(params, otp_app: :aicacia_events) do
      json(conn, %{access_token: access_token})
    end
  end

  @doc """
  token revoke
  """
  @doc parameters: [
         client_id: [
           in: :query,
           type: :string,
           required: true,
           description: "client application id",
           example: "45sdfdsgse53gsdhheths"
         ],
         client_secret: [
           in: :query,
           type: :string,
           required: true,
           description: "client application secret",
           example: "9ppwrfhep9nfwpojfn4s"
         ],
         token: [
           in: :query,
           type: :string,
           required: true,
           description: "token",
           example: "asf8924h0f8ahospdfjkhasklrfh4"
         ]
       ]
  def token_revoke(conn, params) do
    with {:ok, %{}} <- ExOauth2Provider.Token.revoke(params, otp_app: :aicacia_events) do
      conn
      |> put_status(204)
      |> json(%{})
    end
  end
end
