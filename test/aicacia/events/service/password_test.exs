defmodule Aicacia.Events.Service.PasswordTest do
  use Aicacia.Events.Service.Case

  alias Aicacia.Events.Service

  describe "create" do
    test "should create a password" do
      user = Service.User.Create.handle!(%{username: "username"})

      password =
        %{user_id: user.id, password: "password"}
        |> Service.Password.Create.new!()
        |> Service.Password.Create.handle!()

      assert password.user_id == user.id
    end

    test "should not create a password if same as current" do
      user = Service.User.Create.handle!(%{username: "username"})

      %{user_id: user.id, password: "password"}
      |> Service.Password.Create.new!()
      |> Service.Password.Create.handle!()

      assert_raise(Ecto.InvalidChangesetError, fn ->
        %{user_id: user.id, password: "password"}
        |> Service.Password.Create.new!()
        |> Service.Password.Create.handle!()
      end)
    end

    test "should not create a password if already used" do
      user = Service.User.Create.handle!(%{username: "username"})

      %{user_id: user.id, password: "password"}
      |> Service.Password.Create.new!()
      |> Service.Password.Create.handle!()

      %{user_id: user.id, password: "changed_password"}
      |> Service.Password.Create.new!()
      |> Service.Password.Create.handle!()

      assert_raise(Ecto.InvalidChangesetError, fn ->
        %{user_id: user.id, password: "password"}
        |> Service.Password.Create.new!()
        |> Service.Password.Create.handle!()
      end)
    end
  end
end
