defmodule Aicacia.Events.Repo.Migrations.CreateTopics do
  use Ecto.Migration

  def change do
    create table(:topics, primary_key: false) do
      add(:id, :binary_id, primary_key: true)

      add(
        :owner_id,
        references(:users, type: :binary_id, on_delete: :delete_all, on_update: :nothing),
        null: false
      )

      add(
        :application_id,
        references(:oauth_applications,
          type: :binary_id,
          on_delete: :delete_all,
          on_update: :nothing
        ),
        null: false
      )

      add(:name, :string, null: false)
      add(:schema, :map, null: false)

      timestamps(type: :utc_datetime)
    end

    create(index(:topics, [:owner_id]))
    create(index(:topics, [:application_id]))
    create(unique_index(:topics, [:name]))
  end
end
