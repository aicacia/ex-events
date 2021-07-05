defmodule Aicacia.Events.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add(:id, :binary_id, primary_key: true)

      add(
        :user_id,
        references(:users, type: :binary_id, on_delete: :delete_all, on_update: :nothing),
        null: false
      )

      add(
        :topic_id,
        references(:topics,
          type: :binary_id,
          on_delete: :delete_all,
          on_update: :nothing
        ),
        null: false
      )

      add(:data, :map, null: false)

      timestamps(type: :utc_datetime)
    end

    create(index(:events, [:user_id]))
    create(index(:events, [:topic_id]))
  end
end
