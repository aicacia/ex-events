defmodule Aicacia.Events.Service.EmailTest do
  use Aicacia.Events.Service.Case

  alias Aicacia.Events.Model
  alias Aicacia.Events.Service
  alias Aicacia.Events.Repo

  describe "create" do
    test "should create an email" do
      user = Service.User.Create.handle!(%{username: "username"})

      email =
        %{user_id: user.id, email: "email@domain.com"}
        |> Service.Email.Create.new!()
        |> Service.Email.Create.handle!()

      assert email.user_id == user.id

      Repo.get_by!(Model.EmailConfirmationToken, email_id: email.id, user_id: user.id)
    end

    test "should fail on non unique email" do
      user = Service.User.Create.handle!(%{username: "username"})

      %{user_id: user.id, email: "email@domain.com"}
      |> Service.Email.Create.new!()
      |> Service.Email.Create.handle!()

      assert_raise(Ecto.InvalidChangesetError, fn ->
        %{user_id: user.id, email: "email@domain.com"}
        |> Service.Email.Create.new!()
        |> Service.Email.Create.handle!()
      end)
    end
  end

  describe "confirm" do
    test "should confirm an email" do
      user = Service.User.Create.handle!(%{username: "username"})
      email = Service.Email.Create.handle!(%{user_id: user.id, email: "email@domain.com"})

      email_confirmation_token =
        Repo.get_by!(Model.EmailConfirmationToken, email_id: email.id, user_id: user.id)

      email =
        %{confirmation_token: email_confirmation_token.confirmation_token}
        |> Service.Email.Confirm.new!()
        |> Service.Email.Confirm.handle!()

      assert email.confirmed == true
    end
  end

  describe "set primary" do
    test "should set only one email as primary" do
      user = Service.User.Create.handle!(%{username: "username"})
      email1 = Service.Email.Create.handle!(%{user_id: user.id, email: "example1@domain.com"})
      email2 = Service.Email.Create.handle!(%{user_id: user.id, email: "example2@domain.com"})

      email1 = Service.Email.SetPrimary.handle!(%{user_id: user.id, email_id: email1.id})

      assert email1.primary == true

      email2 = Service.Email.SetPrimary.handle!(%{user_id: user.id, email_id: email2.id})

      email1 = Repo.get!(Model.Email, email1.id)

      assert email1.primary == false
      assert email2.primary == true
    end
  end
end
