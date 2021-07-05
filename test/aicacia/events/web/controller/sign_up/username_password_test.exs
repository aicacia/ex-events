defmodule Aicacia.Events.Web.Controller.Api.SignUp.UsernameAndPasswordTest do
  use Aicacia.Events.Web.Case

  setup %{conn: conn} do
    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")}
  end

  describe "username_and_password" do
    test "should sign up with username and password", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.api_username_and_password_path(@endpoint, :sign_up),
          %{
            "username" => "username",
            "password" => "password",
            "password_confirmation" => "password"
          }
        )

      json_response(conn, 201)
    end
  end
end
