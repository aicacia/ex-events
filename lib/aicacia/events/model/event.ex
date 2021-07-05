defmodule Aicacia.Events.Model.Event do
  use Ecto.Schema

  alias Aicacia.Events.Model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    belongs_to(:user, Model.User, type: :binary_id)
    belongs_to(:topic, Model.Topic, type: :binary_id)

    field(:data, :map, null: false)

    timestamps(type: :utc_datetime)
  end
end
