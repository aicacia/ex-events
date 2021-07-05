defmodule Aicacia.Events.Web.Controller.Api.User.Email do
  @moduledoc tags: ["User"]

  use Aicacia.Events.Web, :controller
  use OpenApiSpex.Controller

  alias Aicacia.Events.Service
  alias Aicacia.Events.Web.Controller
  alias Aicacia.Events.Web.View
  alias Aicacia.Events.Web.Schema

  action_fallback(Controller.Api.Fallback)

  @doc """
  Confirm an Eamil

  Confirms an Email and returns the User with the Bearer Token
  """
  @doc responses: [
         ok: {"Confirmed User Email Response", "application/json", Schema.User.Private}
       ],
       parameters: [
         confirmation_token: [
           in: :query,
           type: :string,
           required: true,
           description: "confirmation token",
           example: "pa9u8hf90aw84hfahawhfap9248hfaworf"
         ]
       ],
       security: [%{"authorization" => []}]
  def confirm(conn, params) do
    with {:ok, command} <- Service.Email.Confirm.new(params),
         {:ok, email} <- Service.Email.Confirm.handle(command),
         {:ok, user} <- Service.User.Show.handle(%{id: email.user_id}) do
      conn
      |> put_status(201)
      |> put_view(View.User)
      |> render("private_show.json", user: user)
    end
  end

  @doc """
  Create an Eamil

  Create and returns an Email
  """
  @doc request_body:
         {"Create Email Body", "application/json", Schema.User.EmailCreate, required: true},
       responses: [
         ok: {"Create an Email Response", "application/json", Schema.User.Email}
       ],
       security: [%{"authorization" => []}]
  def create(conn, params) do
    user = ExOauth2Provider.Plug.current_resource_owner(conn)

    with {:ok, command} <-
           Service.Email.Create.new(%{user_id: user.id, email: Map.get(params, "email")}),
         {:ok, email} <- Service.Email.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Email)
      |> render("show.json", email: email)
    end
  end

  @doc """
  Set Email as Primary

  Sets an Email as User's Primary Email
  """
  @doc responses: [
         ok: {"Set Primary Email Response", "application/json", Schema.User.Email}
       ],
       security: [%{"authorization" => []}]
  def set_primary(conn, params) do
    user = ExOauth2Provider.Plug.current_resource_owner(conn)

    with {:ok, command} <-
           Service.Email.SetPrimary.new(%{user_id: user.id, email_id: Map.get(params, "id")}),
         {:ok, email} <- Service.Email.SetPrimary.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Email)
      |> render("show.json", email: email)
    end
  end

  @doc """
  Delete an Email

  Delete a non-primary Email
  """
  @doc responses: [
         ok: {"Delete non-primary Email Response", "application/json", Schema.User.Email}
       ],
       security: [%{"authorization" => []}]
  def delete(conn, params) do
    user = ExOauth2Provider.Plug.current_resource_owner(conn)

    with {:ok, command} <-
           Service.Email.Delete.new(%{user_id: user.id, email_id: Map.get(params, "id")}),
         {:ok, email} <- Service.Email.Delete.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Email)
      |> render("show.json", email: email)
    end
  end
end
