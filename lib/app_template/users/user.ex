defmodule AppTemplate.User do
  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Comeonin.Bcrypt

  @type t :: %__MODULE__{}
  schema "users" do
    field :email, :string
    field :password, :string
    field :new_password, :string, virtual: true
    field :new_password_confirmation, :string, virtual: true
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:email, :new_password, :new_password_confirmation])
    |> validate_required([:email, :new_password, :new_password_confirmation])
    |> update_change(:email, &String.downcase/1)
    |> update_change(:email, &String.trim/1)
    |> validate_format(:email, email_format(), message: "not a valid email address")
    |> validate_confirmation(:new_password)
    |> hash_password
  end

  defp hash_password(changeset) do
    if password = get_change(changeset, :new_password) do
      changeset
      |> put_change(:password, Bcrypt.hashpwsalt(password))
    else
      changeset
    end
  end

  defp email_format do
    ~r/\A[^@]+@[^@]+\z/
  end
end
