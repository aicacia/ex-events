defmodule Aicacia.Events.Web.View.Error do
  use Aicacia.Events.Web, :view

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
