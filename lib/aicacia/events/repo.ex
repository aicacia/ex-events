defmodule Aicacia.Events.Repo do
  use Ecto.Repo,
    otp_app: :aicacia_events,
    adapter: Ecto.Adapters.Postgres

  def run(fun_or_multi, opts \\ []) do
    try do
      Aicacia.Events.Repo.transaction(fun_or_multi, opts)
    rescue
      e -> {:error, e}
    end
  end

  def init(_type, config) do
    {:ok, Keyword.put(config, :url, System.get_env("DATABASE_URL"))}
  end
end
