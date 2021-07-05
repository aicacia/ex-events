defmodule Aicacia.Events.Web.Schema.User do
  alias OpenApiSpex.Schema

  defmodule Email do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "User.Email",
      description: "user email",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        user_id: %Schema{type: :integer, description: "User Id"},
        email: %Schema{type: :string, description: "Email address", format: :email},
        confirmed: %Schema{type: :boolean, description: "Email confirmation status"},
        primary: %Schema{type: :boolean, description: "Email primary status"},
        inserted_at: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updated_at: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [:id, :username, :emails, :inserted_at, :updated_at],
      example: %{
        "id" => 1234,
        "user_id" => 123,
        "email" => "example@domain.com",
        "confirmed" => true,
        "primary" => true,
        "inserted_at" => "2017-09-12T12:34:55Z",
        "updated_at" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule EmailCreate do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "User.EmailCreate",
      description: "create user email",
      type: :object,
      properties: %{
        email: %Schema{type: :string, description: "Email address", format: :email}
      },
      required: [:email],
      example: %{
        "email" => "example@domain.com"
      }
    })
  end

  defmodule PasswordReset do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "User.EmailCreate",
      description: "create user email",
      type: :object,
      properties: %{
        old_password: %Schema{type: :string, description: "old password"},
        password: %Schema{type: :string, description: "password"}
      },
      required: [:old_password, :password],
      example: %{
        "old_password" => "old_password",
        "password" => "password"
      }
    })
  end

  defmodule UsernameUpdate do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "User.UsernameUpdate",
      description: "update user's username",
      type: :object,
      properties: %{
        username: %Schema{type: :string, description: "username"}
      },
      required: [:username],
      example: %{
        "username" => "username"
      }
    })
  end

  defmodule Private do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "User.Private",
      description: "A private user",
      type: :object,
      properties: %{
        id: %Schema{type: :string, description: "Id"},
        token: %Schema{type: :string, description: "User Token"},
        username: %Schema{type: :string, description: "User name"},
        email: Email,
        emails: %Schema{type: :array, items: Email},
        inserted_at: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updated_at: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [:id, :username, :emails, :inserted_at, :updated_at],
      example: %{
        "id" => "123e4567-e89b-12d3-a456-426614174000",
        "token" => "a9psd8fhaowntw4iojha3084tjhap4jtq34tojapsjgaaaat5j955357f",
        "username" => "example",
        "email" => %{
          "id" => 1234,
          "user_id" => 123,
          "email" => "example@domain.com",
          "confirmed" => true,
          "primary" => true,
          "inserted_at" => "2017-09-12T12:34:55Z",
          "updated_at" => "2017-09-13T10:11:12Z"
        },
        "emails" => [],
        "inserted_at" => "2017-09-12T12:34:55Z",
        "updated_at" => "2017-09-13T10:11:12Z"
      }
    })
  end
end
