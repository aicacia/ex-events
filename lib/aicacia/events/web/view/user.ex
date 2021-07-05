defmodule Aicacia.Events.Web.View.User do
  use Aicacia.Events.Web, :view

  alias Aicacia.Events.Web.View.User
  alias Aicacia.Events.Web.View.Email

  def render("index.json", %{users: users}) do
    render_many(users, User, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, User, "user.json")
  end

  def render("private_show.json", %{user: user}) do
    render_one(user, User, "private_user.json")
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end

  def render("private_user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: render_email(user.emails),
      emails:
        render_many(
          Enum.filter(user.emails, fn email -> not email.primary end),
          Email,
          "email.json"
        ),
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end

  defp render_email(emails) do
    case primary_email(emails) do
      nil ->
        nil

      email ->
        render_one(email, Email, "email.json")
    end
  end

  defp primary_email(emails) do
    case emails
         |> Enum.filter(fn email -> email.confirmed and email.primary end)
         |> Enum.at(0) do
      nil ->
        nil

      email ->
        email
    end
  end
end
