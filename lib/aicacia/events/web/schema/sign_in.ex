defmodule Aicacia.Events.Web.Schema.SignIn do
  alias OpenApiSpex.Schema

  defmodule UsernameOrEmailAndPassword do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "SignIn.UsernameOrEmailAndPassword",
      description: "user sign in with username or email and password",
      type: :object,
      properties: %{
        username_or_email: %Schema{type: :string, description: "Email or Username"},
        password: %Schema{type: :string, description: "Password"}
      },
      required: [:password, :password_confirmation],
      example: %{
        "username_or_email" => "example@domain.com",
        "password" => "password"
      }
    })
  end
end
