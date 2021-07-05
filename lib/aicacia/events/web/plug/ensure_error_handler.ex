defmodule Aicacia.Events.Web.Plug.EnsureErrorHandler do
  use Phoenix.Controller, namespace: Aicacia.Events.Web

  import Plug.Conn
  alias Aicacia.Events.Web.View

  def no_resource(conn, _params) do
    conn
    |> put_status(:not_found)
    |> put_view(View.Error)
    |> render(:"404")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> put_view(View.Error)
    |> render(:"401")
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> put_view(View.Error)
    |> render(:"403")
  end
end
