defmodule Aicacia.Events.Service.Password.Create do
  use Aicacia.Handler
  import Ecto.Query
  import Ecto.Changeset

  alias Aicacia.Events.Model
  alias Aicacia.Events.Repo

  @primary_key false
  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    field(:password, :string)
    field(:encrypted_password, :string)
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:user_id, :password])
    |> validate_required([:user_id, :password])
    |> validate_length(:password, min: 8)
    |> foreign_key_constraint(:user_id)
    |> encrypt_password()
    |> validate_password_not_current()
    |> validate_password_not_already_used()
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      case Repo.get_by(Model.Password, user_id: command.user_id) do
        nil ->
          nil

        old_password ->
          %Model.OldPassword{}
          |> cast(
            %{user_id: command.user_id, encrypted_password: old_password.encrypted_password},
            [:user_id, :encrypted_password]
          )
          |> foreign_key_constraint(:user_id)
          |> unique_constraint(:encrypted_password,
            name: :old_passwords_user_id_encrypted_password_index
          )
          |> Repo.insert!()

          Repo.delete!(old_password)
      end

      %Model.Password{}
      |> cast(
        %{user_id: command.user_id, encrypted_password: command.encrypted_password},
        [:user_id, :encrypted_password]
      )
      |> foreign_key_constraint(:user_id)
      |> unique_constraint(:encrypted_password)
      |> Repo.insert!()
    end)
  end

  def encrypt_password(changeset) do
    case get_field(changeset, :password) do
      nil ->
        changeset

      password ->
        put_change(changeset, :encrypted_password, Bcrypt.hash_pwd_salt(password))
    end
  end

  def validate_password_not_current(changeset) do
    user_id = get_field(changeset, :user_id)
    password = get_field(changeset, :password)

    case Repo.get_by(Model.Password,
           user_id: user_id
         ) do
      nil ->
        changeset

      %Model.Password{encrypted_password: encrypted_password} ->
        if Bcrypt.verify_pass(password, encrypted_password) do
          add_error(changeset, :password, "cannot be current password")
        else
          changeset
        end
    end
  end

  def validate_password_not_already_used(changeset) do
    user_id = get_field(changeset, :user_id)

    case from(p in Model.OldPassword,
           where: p.user_id == ^user_id
         )
         |> Repo.all() do
      [] ->
        changeset

      old_passwords ->
        validate_password_not_already_used(changeset, old_passwords, 0)
    end
  end

  defp validate_password_not_already_used(changeset, old_passwords, index) do
    case Enum.at(old_passwords, index) do
      nil ->
        changeset

      old_password ->
        password = get_field(changeset, :password)

        if Bcrypt.verify_pass(password, old_password.encrypted_password) do
          add_error(changeset, :password, "cannot be one of old passwords")
        else
          validate_password_not_already_used(changeset, old_passwords, index + 1)
        end
    end
  end
end
