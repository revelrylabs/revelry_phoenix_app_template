defmodule AppTemplate.User do
  use Ecto.Schema
  use Pow.Ecto.Schema, password_hash_methods: {&Bcrypt.hash_pwd_salt/1, &Bcrypt.verify_pass/2}
  use Adminable
  import Ecto.{Query, Changeset}, warn: false

  @type t :: %__MODULE__{}
  schema "users" do
    pow_user_fields()
    field(:admin, :boolean, default: false)
    field(:email_verified, :boolean, default: false)
    timestamps()
  end

  def changeset(model, attrs \\ %{}) do
    model
    |> pow_changeset(attrs)
  end

  def update_changeset(model, attrs \\ %{}) do
    model
    |> pow_changeset(attrs)
  end

  def edit_changeset(model, attrs \\ %{}) do
    model
    |> pow_changeset(attrs)
  end

  def create_changeset(schema, data) do
    changeset(schema, data)
  end
end
