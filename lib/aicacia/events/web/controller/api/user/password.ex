defmodule Aicacia.Events.Web.Controller.Api.User.Password do
  @moduledoc tags: ["User"]

  use Aicacia.Events.Web, :controller
  use OpenApiSpex.Controller

  alias Aicacia.Events.{Service, Model, Repo}
  alias Aicacia.Events.Web.Schema
  alias Aicacia.Events.Web.Controller

  action_fallback(Controller.Api.Fallback)

  @doc """
  Reset Password

  Resets the User's Password and invalids all tokens at the same time
  """
  @doc request_body:
         {"reset user password", "application/json", Schema.User.PasswordReset, required: true},
       responses: [
         ok: {"Confirmed User Email Response", "application/json", Schema.User.Private}
       ],
       security: [%{"authorization" => []}]
  def reset(conn, params) do
    access_token = ExOauth2Provider.Plug.current_access_token(conn)
    user = Service.User.Show.get_user!(access_token.resource_owner_id)

    with {:ok, command} <-
           Service.Password.Reset.new(%{
             user_id: user.id,
             old_password: Map.get(params, "old_password"),
             password: Map.get(params, "password")
           }),
         {:ok, _password} <- Service.Password.Reset.handle(command),
         :ok <- revoke_all_tokens(user) do
      Aicacia.Events.Web.Controller.Api.User.sign_in_user(conn, user, 201)
    end
  end

  defp revoke_all_tokens(%Model.User{} = user) do
    %{uid: uid, secret: secret} =
      Repo.get_by!(AicaciaEvents.OauthApplications.OauthApplication,
        name: "com.aicacia.events.api"
      )

    ExOauth2Provider.AccessTokens.get_authorized_tokens_for(user, otp_app: :aicacia_events)
    |> Enum.each(fn %AicaciaEvents.OauthAccessTokens.OauthAccessToken{token: token} ->
      ExOauth2Provider.Token.revoke(
        %{
          client_id: uid,
          client_secret: secret,
          token: token
        },
        otp_app: :aicacia_events
      )
    end)

    :ok
  end
end
