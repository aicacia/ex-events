defmodule Aicacia.Events.Web.Controller.Api.User.PasswordTest do
  use Aicacia.Events.Web.Case

  alias Aicacia.Events.Service

  setup %{conn: conn} do
    user = Service.User.Create.handle!(%{username: "username"})
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

  describe "password reset" do
    test "should reset password", %{conn: conn, user: user} do
      _old_password =
        %{
          user_id: user.id,
          password: "old_password"
        }
        |> Service.Password.Create.new!()
        |> Service.Password.Create.handle!()

      conn =
        put(
          conn,
          Routes.api_password_path(@endpoint, :reset),
          %{
            "old_password" => "old_password",
            "password" => "password"
          }
        )

      json_response(conn, 201)
    end

    test "should fail to reset password if old password is invalid", %{conn: conn, user: user} do
      _old_password =
        %{
          user_id: user.id,
          password: "old_password"
        }
        |> Service.Password.Create.new!()
        |> Service.Password.Create.handle!()

      conn =
        put(
          conn,
          Routes.api_password_path(@endpoint, :reset),
          %{
            "old_password" => "invalid_old_password",
            "password" => "password"
          }
        )

      json_response(conn, 422)
    end
  end
end
