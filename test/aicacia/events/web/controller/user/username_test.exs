defmodule Aicacia.Events.Web.Controller.Api.User.UsernameTest do
  use Aicacia.Events.Web.Case

  alias Aicacia.Events.Service

  setup %{conn: conn} do
    user = Service.User.Create.handle!(%{username: "old_username"})
    access_token = Aicacia.Events.Web.Controller.Api.User.access_token(user)
    conn = ExOauth2Provider.Plug.set_current_access_token(conn, access_token)

    {:ok,
     user: user,
     conn:
       conn
       |> put_req_header(
         "authorization",
         "Bearer " <> access_token.token
       )
       |> put_req_header("accept", "application/json")}
  end

  describe "update username" do
    test "should update user's username", %{conn: conn, user: user} do
      request_body =
        OpenApiSpex.Schema.example(Aicacia.Events.Web.Schema.User.UsernameUpdate.schema())

      conn =
        patch(
          conn,
          Routes.api_username_path(@endpoint, :update),
          request_body
        )

      assert user.username == "old_username"

      user = json_response(conn, 200)

      assert user["username"] == "username"
    end

    test "should fail to update user's username if already in use", %{conn: conn} do
      Service.User.Create.handle!(%{username: "username"})

      request_body =
        OpenApiSpex.Schema.example(Aicacia.Events.Web.Schema.User.UsernameUpdate.schema())

      conn =
        patch(
          conn,
          Routes.api_username_path(@endpoint, :update),
          request_body
        )

      user = json_response(conn, 422)

      assert user["errors"]["username"] == ["has already been taken"]
    end
  end
end
