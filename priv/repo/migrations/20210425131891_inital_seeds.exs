defmodule Aicacia.Events.Repo.Migrations.InitalSeeds do
  use Ecto.Migration

  alias Aicacia.Events.{Repo, Service}

  def up do
    Repo.transaction(fn ->
      admin_user =
        Service.SignUp.UsernameAndPassword.handle!(%{
          username: System.get_env("ADMIN_USERNAME"),
          password: System.get_env("ADMIN_PASSWORD")
        })

      {:ok, _application} =
        ExOauth2Provider.Applications.create_application(
          admin_user,
          %{
            name: "com.aicacia.events.api",
            redirect_uri: "https://api.events.aicacia.com",
            scopes: "read write"
          },
          otp_app: :aicacia_events
        )
    end)
  end
end
