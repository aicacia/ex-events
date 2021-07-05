defmodule Aicacia.Events.Service.SignUp.UsernameAndPassword do
  use Aicacia.Handler
  import Ecto.Changeset

  alias Aicacia.Events.Service
  alias Aicacia.Events.Repo

  @primary_key false
  schema "" do
    field(:username, :string)
    field(:password, :string)
    field(:password_confirmation, :string)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:username, :password, :password_confirmation])
    |> validate_confirmation(:password)
    |> validate_required([:username, :password, :password_confirmation])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      user = Service.User.Create.create_user!(command)

      _password =
        %{user_id: user.id, password: command.password}
        |> Service.Password.Create.new!()
        |> Service.Password.Create.handle!()

      Service.User.Show.get_user!(user.id)
    end)
  end
end
