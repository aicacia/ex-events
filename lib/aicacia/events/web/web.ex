defmodule Aicacia.Events.Web do
  def controller do
    quote do
      use Phoenix.Controller, namespace: Aicacia.Events.Web

      import Plug.Conn
      import Aicacia.Events.Gettext
      alias Aicacia.Events.Web.Router.Helpers, as: Routes
    end
  end

  def plug do
    quote do
      use Phoenix.Controller, namespace: Aicacia.Events.Web
      import Plug.Conn
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/aicacia/id/web/templates",
        namespace: Aicacia.Events.Web

      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import Aicacia.Events.Gettext
    end
  end

  defp view_helpers do
    quote do
      use Phoenix.HTML

      import Phoenix.LiveView.Helpers

      import Phoenix.View

      import Aicacia.Events.Web.View.ErrorHelpers
      import Aicacia.Events.Gettext
      alias Aicacia.Events.Web.Router.Helpers, as: Routes
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
