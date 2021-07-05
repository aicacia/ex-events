defmodule Aicacia.Events.Model.User do
  use Ecto.Schema

  alias Aicacia.Events.Model
  alias AicaciaEvents.OauthApplications.OauthApplication

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    has_many(:emails, Model.Email)

    has_one(:password, Model.Password)
    has_many(:old_passwords, Model.OldPassword)

    has_many(:applications, OauthApplication, foreign_key: :owner_id)

    field(:username, :string, null: false)
    field(:active, :boolean, null: false, default: true)

    timestamps(type: :utc_datetime)
  end
end
