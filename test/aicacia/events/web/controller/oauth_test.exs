defmodule Aicacia.Events.Web.Controller.OauthTest do
  use Aicacia.Events.Web.Case

  alias Aicacia.Events.Service

  setup %{conn: conn} do
    user = Service.User.Create.handle!(%{username: "username"})
    access_token = Aicacia.Events.Web.Controller.Api.User.access_token(user)
    conn = ExOauth2Provider.Plug.set_current_access_token(conn, access_token)

    {:ok, application} =
      ExOauth2Provider.Applications.create_application(
        user,
        %{name: "Aicacia Events", redirect_uri: "https://example.com"},
        otp_app: :aicacia_events
      )

    {:ok,
     user: user,
     application: application,
     conn:
       conn
       |> put_req_header(
         "authorization",
         "Bearer " <> access_token.token
       )
       |> put_req_header("accept", "application/json")}
  end

  describe "authorize" do
    test "should authorize application", %{conn: conn, application: application} do
      conn =
        get(
          conn,
          Routes.api_oauth_path(@endpoint, :preauthorize, %{
            "response_type" => "code",
            "redirect_uri" => "urn:ietf:wg:oauth:2.0:oob",
            "scope" => "read",
            "client_id" => application.uid
          })
        )

      %{"client" => _client} = json_response(conn, 200)
    end
  end

  describe "grant" do
    test "should authorize application", %{conn: conn, application: application} do
      code_conn =
        post(
          conn,
          Routes.api_oauth_path(@endpoint, :authorize, %{
            "response_type" => "code",
            "redirect_uri" => "urn:ietf:wg:oauth:2.0:oob",
            "scope" => "read",
            "client_id" => application.uid
          })
        )

      %{"code" => code} = json_response(code_conn, 200)

      grant_conn =
        post(
          conn,
          Routes.api_oauth_path(@endpoint, :token_grant, %{
            "response_type" => "code",
            "redirect_uri" => "urn:ietf:wg:oauth:2.0:oob",
            "client_id" => application.uid,
            "client_secret" => application.secret,
            "grant_type" => "authorization_code",
            "code" => code
          })
        )

      %{"access_token" => %{"access_token" => access_token, "refresh_token" => refresh_token}} =
        json_response(grant_conn, 200)

      assert is_binary(access_token)
      assert is_binary(refresh_token)
    end
  end
end
