defmodule Aicacia.Events.Web.Schema.SignUp do
  alias OpenApiSpex.Schema

  defmodule UsernamePassword do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "SignUp.UsernamePassword",
      description: "user sign up with username and password",
      type: :object,
      properties: %{
        username: %Schema{type: :string, description: "Username"},
        password: %Schema{type: :string, description: "Password"},
        password_confirmation: %Schema{type: :string, description: "Password confirmation"}
      },
      required: [:username, :password, :password_confirmation],
      example: %{
        "username" => "username",
        "password" => "password",
        "password_confirmation" => "password"
      }
    })
  end
end
