defmodule Aicacia.Events.Web.View.AccessToken do
  use Aicacia.Events.Web, :view

  alias Aicacia.Events.Web.View.AccessToken

  def render("index.json", %{access_tokens: access_tokens}),
    do: render_many(access_tokens, AccessToken, "access_token.json")

  def render("show.json", %{access_token: access_token}),
    do: render_one(access_token, AccessToken, "access_token.json")

  def render("access_token.json", %{access_token: access_token}),
    do: %{
      id: access_token.id,
      token: access_token.token,
      refresh_token: access_token.refresh_token,
      expires_in: access_token.expires_in,
      revoked_at: access_token.revoked_at,
      scopes: access_token.scopes,
      previous_refresh_token: access_token.previous_refresh_token,
      resource_owner_id: access_token.resource_owner_id,
      application_id: access_token.application_id,
      inserted_at: access_token.inserted_at,
      updated_at: access_token.updated_at
    }
end
