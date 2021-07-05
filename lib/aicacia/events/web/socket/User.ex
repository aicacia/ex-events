defmodule Aicacia.Events.Web.Socket.User do
  use Phoenix.Socket

  def connect(_params, socket, _connect_info), do:
    {:ok, assign(socket, :uuid, Ecto.UUID.generate())}

  def id(socket), do: "#{socket.assigns.uuid}"
end
