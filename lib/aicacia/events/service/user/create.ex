defmodule Aicacia.Events.Service.User.Create do
  use Aicacia.Handler

  alias Aicacia.Events.Model
  alias Aicacia.Events.Repo

  @username_regex ~r/[a-zA-Z0-9\-_]+/i

  def username_regex, do: @username_regex

  @primary_key false
  schema "" do
    field(:username, :string, null: false)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> validate_format(:username, @username_regex)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      create_user!(command)
      |> Repo.preload([:emails, :password])
    end)
  end

  def create_user!(%{} = attrs) do
    %Model.User{}
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
    |> Repo.insert!()
  end
end
