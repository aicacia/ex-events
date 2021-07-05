defmodule Aicacia.Events.Web.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Plug.Conn
      import Phoenix.ConnTest
      alias Aicacia.Events.Web.Router.Helpers, as: Routes

      @endpoint Aicacia.Events.Web.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Aicacia.Events.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Aicacia.Events.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
