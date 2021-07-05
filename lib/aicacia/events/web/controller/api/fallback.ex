defmodule Aicacia.Events.Web.Controller.Api.Fallback do
  use Aicacia.Events.Web, :controller

  alias Aicacia.Events.Web.View

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(View.Changeset)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, %Ecto.InvalidChangesetError{changeset: changeset}}) do
    call(conn, {:error, changeset})
  end

  def call(conn, {:error, %Ecto.NoResultsError{}}) do
    conn
    |> put_status(:not_found)
    |> put_view(View.Error)
    |> render(:"404")
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset, status}) do
    conn
    |> put_status(status)
    |> put_view(View.Changeset)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, error, status}) when is_atom(error) do
    conn
    |> put_status(status)
    |> put_view(View.Error)
    |> json(%{errors: %{detail: error}})
  end
end
