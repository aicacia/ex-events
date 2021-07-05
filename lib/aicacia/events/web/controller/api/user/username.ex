defmodule Aicacia.Events.Web.Controller.Api.User.Username do
  @moduledoc tags: ["User"]

  use Aicacia.Events.Web, :controller
  use OpenApiSpex.Controller

  alias Aicacia.Events.Service
  alias Aicacia.Events.Web.Controller
  alias Aicacia.Events.Web.View
  alias Aicacia.Events.Web.Schema

  action_fallback(Controller.Api.Fallback)

  @doc """
  Update User's Username

  Updates a User's Username
  """
  @doc request_body:
         {"Update User's Username Body", "application/json", Schema.User.UsernameUpdate,
          required: true},
       responses: [
         ok: {"Update User's Username Response", "application/json", Schema.User.Private}
       ],
       security: [%{"authorization" => []}]
  def update(conn, params) do
    access_token = ExOauth2Provider.Plug.current_access_token(conn)
    user = Service.User.Show.get_user!(access_token.resource_owner_id)

    with {:ok, command} <-
           Service.User.Update.new(%{id: user.id, username: Map.get(params, "username")}),
         {:ok, user} <- Service.User.Update.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.User)
      |> render("private_show.json", user: user)
    end
  end
end
