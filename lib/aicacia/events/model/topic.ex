defmodule Aicacia.Events.Model.Topic do
  use Ecto.Schema

  alias Aicacia.Events.Model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "topics" do
    belongs_to(:application, AicaciaEvents.OauthApplications.OauthApplication, type: :binary_id)
    belongs_to(:owner, Model.User, type: :binary_id)
    has_many(:events, Model.Event)

    field(:name, :string, null: false)
    field(:schema, :map, null: false)

    timestamps(type: :utc_datetime)
  end
end
