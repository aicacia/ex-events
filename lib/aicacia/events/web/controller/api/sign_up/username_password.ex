defmodule Aicacia.Events.Web.Controller.Api.SignUp.UsernameAndPassword do
  @moduledoc tags: ["User"]

  use Aicacia.Events.Web, :controller

  alias Aicacia.Events.Service
  use OpenApiSpex.Controller

  alias Aicacia.Events.Web.Schema

  action_fallback(Aicacia.Events.Web.Controller.Api.Fallback)

  @doc """
  Sign up

  Signs up a user and returns Access Token
  """
  @doc request_body:
         {"Request body to sign up", "application/json", Schema.SignUp.UsernamePassword,
          required: true},
       responses: [
         ok: {"Sign up User Response", "application/json", Schema.User.Private}
       ]
  def sign_up(conn, params) do
    with {:ok, command} <- Service.SignUp.UsernameAndPassword.new(params),
         {:ok, user} <- Service.SignUp.UsernameAndPassword.handle(command) do
      Aicacia.Events.Web.Controller.Api.User.sign_in_user(conn, user, 201)
    end
  end
end
