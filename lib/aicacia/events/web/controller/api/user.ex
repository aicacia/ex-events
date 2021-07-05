defmodule Aicacia.Events.Web.Controller.Api.User do
  @moduledoc tags: ["User"]

  use Aicacia.Events.Web, :controller
  use OpenApiSpex.Controller

  alias Aicacia.Events.Model
  alias Aicacia.Events.Repo
  alias Aicacia.Events.Service
  alias Aicacia.Events.Web.View
  alias Aicacia.Events.Web.Schema
  alias AicaciaEvents.OauthApplications.OauthApplication

  action_fallback(Aicacia.Events.Web.Controller.Api.Fallback)

  @doc """
  Gets the Current User

  Returns the current user based on the bearer token
  """
  @doc responses: [
         ok: {"Current User Response", "application/json", Schema.User.Private}
       ],
       security: [%{"authorization" => []}]
  def current(conn, _params) do
    access_token = ExOauth2Provider.Plug.current_access_token(conn)
    user = Service.User.Show.get_user!(access_token.resource_owner_id)

    conn
    |> put_view(View.User)
    |> render("private_show.json", user: user)
  end

  @doc """
  Deactivates the Current User

  Deactivates the current User's account
  """
  @doc responses: [
         no_content: "Empty response"
       ],
       security: [%{"authorization" => []}]
  def deactivate(conn, _params) do
    access_token = ExOauth2Provider.Plug.current_access_token(conn)

    with {:ok, command} <-
           Service.User.Deactivate.new(%{user_id: access_token.resource_owner_id}),
         {:ok, _user} <- Service.User.Deactivate.handle(command) do
      conn
      |> put_status(204)
      |> json(%{})
    end
  end

  @doc """
  Sign current User out

  Signs out the current User based on the bearer token
  """
  @doc responses: [
         no_content: "Empty response"
       ],
       security: [%{"authorization" => []}]
  def sign_out(conn, _params) do
    access_token = ExOauth2Provider.Plug.current_access_token(conn)

    case revoke_access_token(access_token.token) do
      {:ok, %{}} ->
        conn
        |> put_status(204)
        |> json(%{})

      {:error, error, http_status} ->
        conn
        |> put_status(http_status)
        |> json(error)
    end
  end

  def revoke_access_token(token) do
    %OauthApplication{uid: uid, secret: secret} =
      Repo.get_by!(OauthApplication,
        name: "com.aicacia.events.api"
      )

    ExOauth2Provider.Token.revoke(
      %{
        client_id: uid,
        client_secret: secret,
        token: token
      },
      otp_app: :aicacia_events
    )
  end

  def access_token(%Model.User{} = resource_owner) do
    {:ok, access_token} =
      ExOauth2Provider.AccessTokens.create_token(
        resource_owner,
        %{
          application:
            Repo.get_by!(OauthApplication,
              name: "com.aicacia.events.api"
            ),
          scopes: "write"
        },
        otp_app: :aicacia_events
      )

    access_token
  end

  def sign_in_user(conn, resource_owner, status \\ 200)

  def sign_in_user(conn, %Model.User{} = resource_owner, status) do
    conn
    |> put_status(status)
    |> put_view(View.AccessToken)
    |> render("access_token.json", access_token: access_token(resource_owner))
  end

  def sign_in_user(conn, _resource_owner, _status) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(View.Error)
    |> render(:"500")
  end
end
