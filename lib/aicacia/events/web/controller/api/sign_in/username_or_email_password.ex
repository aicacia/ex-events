defmodule Aicacia.Events.Web.Controller.Api.SignIn.UsernameOrEmailAndPassword do
  @moduledoc tags: ["User"]

  use Aicacia.Events.Web, :controller
  use OpenApiSpex.Controller

  alias Aicacia.Events.Service
  alias Aicacia.Events.Web.Schema

  action_fallback(Aicacia.Events.Web.Controller.Api.Fallback)

  @doc """
  Sign in

  Signs in user and returns the Access Token
  """
  @doc request_body:
         {"Request body to sign in", "application/json", Schema.SignIn.UsernameOrEmailAndPassword,
          required: true},
       responses: [
         ok: {"Sign in User Response", "application/json", Schema.User.Private}
       ]
  def sign_in(conn, params) do
    with {:ok, command} <- Service.SignIn.UsernameOrEmailAndPassword.new(params),
         {:ok, user} <- Service.SignIn.UsernameOrEmailAndPassword.handle(command) do
      Aicacia.Events.Web.Controller.Api.User.sign_in_user(conn, user, 200)
    end
  end
end
