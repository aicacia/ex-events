defmodule Aicacia.Events.Model.Email do
  use Ecto.Schema

  alias Aicacia.Events.Model

  schema "emails" do
    belongs_to(:user, Model.User, type: :binary_id)

    field(:email, :string, null: false)
    field(:primary, :boolean, null: false, default: false)
    field(:confirmed, :boolean, null: false, default: false)

    timestamps(type: :utc_datetime)
  end
end
