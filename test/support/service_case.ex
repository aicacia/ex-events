defmodule Aicacia.Events.Service.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Aicacia.Events.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Aicacia.Events.Service.Case
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Aicacia.Events.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Aicacia.Events.Repo, {:shared, self()})
    end

    :ok
  end

  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
