defmodule Aicacia.Events.Service.Password.Reset do
  use Aicacia.Handler

  alias Aicacia.Events.Model
  alias Aicacia.Events.Service
  alias Aicacia.Events.Repo

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    field(:old_password, :string)
    field(:password, :string)
    field(:encrypted_password, :string)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id, :old_password, :password])
    |> validate_required([:user_id, :old_password, :password])
    |> foreign_key_constraint(:user_id)
    |> Service.Password.Create.encrypt_password()
    |> Service.Password.Create.validate_password_not_current()
    |> Service.Password.Create.validate_password_not_already_used()
    |> validate_old_password()
  end

  def handle(%{} = command) do
    Service.Password.Create.handle(command)
  end

  def validate_old_password(changeset) do
    case Repo.get_by!(Model.Password, user_id: get_field(changeset, :user_id)) do
      nil ->
        add_error(changeset, :old_password, "old password does not match")

      old_password ->
        case Bcrypt.verify_pass(
               get_field(changeset, :old_password, ""),
               old_password.encrypted_password
             ) do
          true ->
            changeset

          false ->
            add_error(changeset, :old_password, "old password does not match")
        end
    end
  end
end
