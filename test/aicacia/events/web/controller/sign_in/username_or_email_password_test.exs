defmodule Aicacia.Events.Web.Controller.Api.SignIn.UsernameOrEmailPasswordTest do
  use Aicacia.Events.Web.Case

  alias Aicacia.Events.Service

  setup %{conn: conn} do
    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")}
  end

  describe "username_or_email_and_password" do
    test "should sign in with email and password", %{conn: conn} do
      user = create_user!()

      conn =
        post(
          conn,
          Routes.api_username_or_email_and_password_path(@endpoint, :sign_in),
          %{
            "username_or_email" => "email@domain.com",
            "password" => "password"
          }
        )

      access_token_json = json_response(conn, 200)

      assert access_token_json["resource_owner_id"] == user.id
    end

    test "should sign in with username and password", %{conn: conn} do
      user = create_user!()

      conn =
        post(
          conn,
          Routes.api_username_or_email_and_password_path(@endpoint, :sign_in),
          %{
            "username_or_email" => "username",
            "password" => "password"
          }
        )

      access_token_json = json_response(conn, 200)

      assert access_token_json["resource_owner_id"] == user.id
    end

    test "should fail to sign in with invalid email", %{conn: conn} do
      _user = create_user!()

      conn =
        post(
          conn,
          Routes.api_username_or_email_and_password_path(@endpoint, :sign_in),
          %{
            "username_or_email" => "wrong@domain.com",
            "password" => "password"
          }
        )

      error_json = json_response(conn, 422)

      assert error_json["errors"]["username_or_email"] == [
               Service.SignIn.UsernameOrEmailAndPassword.no_match_error()
             ]

      assert error_json["errors"]["password"] == [
               Service.SignIn.UsernameOrEmailAndPassword.no_match_error()
             ]
    end

    test "should fail to sign in with invalid password", %{conn: conn} do
      _user = create_user!()

      conn =
        post(
          conn,
          Routes.api_username_or_email_and_password_path(@endpoint, :sign_in),
          %{
            "username_or_email" => "email@domain.com",
            "password" => "wrong"
          }
        )

      error_json = json_response(conn, 422)

      assert error_json["errors"]["username_or_email"] == [
               Service.SignIn.UsernameOrEmailAndPassword.no_match_error()
             ]

      assert error_json["errors"]["password"] == [
               Service.SignIn.UsernameOrEmailAndPassword.no_match_error()
             ]
    end
  end

  defp create_user!() do
    user = Service.User.Create.handle!(%{username: "username"})

    Service.Email.Create.handle!(%{user_id: user.id, email: "email@domain.com"})

    Service.Password.Create.new!(%{user_id: user.id, password: "password"})
    |> Service.Password.Create.handle!()

    Service.User.Show.handle!(%{id: user.id})
  end
end
