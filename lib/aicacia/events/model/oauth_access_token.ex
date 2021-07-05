defmodule AicaciaEvents.OauthAccessTokens.OauthAccessToken do
  use Ecto.Schema
  use ExOauth2Provider.AccessTokens.AccessToken, otp_app: :aicacia_events

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "oauth_access_tokens" do
    access_token_fields()

    timestamps()
  end
end
