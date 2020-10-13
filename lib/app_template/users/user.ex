defmodule AppTemplate.User do
  use Ecto.Schema
  use Pow.Ecto.Schema, password_hash_methods: {&Bcrypt.hash_pwd_salt/1, &Bcrypt.verify_pass/2}

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]

  use Adminable
  import Ecto.{Query, Changeset}, warn: false

  @type t :: %__MODULE__{}
  schema "users" do
    pow_user_fields()
    field(:role, :string, default: "user")
    timestamps()
  end

  def changeset(schema, attrs \\ %{}) do
    schema
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end

  def update_changeset(schema, attrs \\ %{}) do
    changeset(schema, attrs)
  end

  def edit_changeset(schema, attrs \\ %{}) do
    changeset(schema, attrs)
  end

  def create_changeset(schema, attrs) do
    changeset(schema, attrs)
  end
end
