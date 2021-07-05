defmodule Aicacia.Events.Service.User.Show do
  use Aicacia.Handler
  import Ecto.Query

  alias Aicacia.Events.Model
  alias Aicacia.Events.Repo

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "" do
  end

  def changeset(%{} = params) do
    %__MODULE__{}
    |> cast(params, [:id])
    |> validate_required([:id])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      get_user!(command.id)
    end)
  end

  def get_user!(id),
    do:
      from(u in Model.User,
        where: u.id == ^id,
        preload: [:emails, :password]
      )
      |> Repo.one!()
end
