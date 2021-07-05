defmodule Aicacia.Events.Model.Password do
  use Ecto.Schema

  alias Aicacia.Events.Model

  schema "passwords" do
    belongs_to(:user, Model.User, type: :binary_id)

    field(:encrypted_password, :string, null: false)

    timestamps(type: :utc_datetime)
  end
end
