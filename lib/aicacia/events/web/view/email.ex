defmodule Aicacia.Events.Web.View.Email do
  use Aicacia.Events.Web, :view

  alias Aicacia.Events.Web.View.Email

  def render("index.json", %{emails: emails}), do: render_many(emails, Email, "email.json")

  def render("show.json", %{email: email}), do: render_one(email, Email, "email.json")

  def render("email.json", %{email: email}),
    do: %{
      id: email.id,
      user_id: email.user_id,
      email: email.email,
      confirmed: email.confirmed,
      primary: email.primary,
      inserted_at: email.inserted_at,
      updated_at: email.updated_at
    }
end
