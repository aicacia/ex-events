defmodule Aicacia.Events.Web.Controller.UserTest do
  use Aicacia.Events.Web.Case

  alias Aicacia.Events.Service

  setup %{conn: conn} do
    user = Service.User.Create.handle!(%{username: "username"})

    {:ok,
     user: user,
     conn:
       conn
       |> put_req_header("accept", "application/json")}
  end

  describe "current" do
    test "should return current user", %{conn: conn, user: user} do
      access_token = Aicacia.Events.Web.Controller.Api.User.access_token(user)
      conn = ExOauth2Provider.Plug.set_current_access_token(conn, access_token)

      conn =
        get(
          conn
          |> put_req_header(
            "authorization",
            "Bearer " <> access_token.token
          ),
          Routes.api_user_path(@endpoint, :current)
        )

      user_json = json_response(conn, 200)

      assert user_json["id"] == user.id
    end

    test "should return 401 with invalid token", %{conn: conn} do
      conn =
        get(
          conn,
          Routes.api_user_path(@endpoint, :current)
        )

      json_response(conn, 401)
    end
  end

  describe "sign_out" do
    test "should sign out current user", %{conn: conn, user: user} do
      access_token = Aicacia.Events.Web.Controller.Api.User.access_token(user)
      conn = ExOauth2Provider.Plug.set_current_access_token(conn, access_token)

      conn =
        delete(
          conn
          |> put_req_header(
            "authorization",
            "Bearer " <> access_token.token
          ),
          Routes.api_user_path(@endpoint, :sign_out)
        )

      response(conn, 204)
    end
  end
end
