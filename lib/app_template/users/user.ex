defmodule AppTemplate.User do
  use Ecto.Schema
  use Adminable
  import Ecto.{Query, Changeset}, warn: false
  alias Bcrypt

  @type t :: %__MODULE__{}
  schema "users" do
    field(:email, :string)
    field(:password, :string)
    field(:current_password, :string, virtual: true)
    field(:admin, :boolean, default: false)
    field(:email_verified, :boolean, default: false)
    timestamps()

    field(:new_password, :string, virtual: true)
    field(:new_password_confirmation, :string, virtual: true)
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:email, :new_password, :new_password_confirmation])
    |> validate_required([:email, :new_password, :new_password_confirmation])
    |> update_change(:email, &String.downcase/1)
    |> update_change(:email, &String.trim/1)
    |> unique_constraint(:email, message: "already in use", name: :users_lower_email_index)
    |> validate_format(:email, email_format(), message: "not a valid email address")
    |> validate_confirmation(:new_password)
    |> hash_password
  end

  def update_changeset(model, params \\ %{}) do
    model
    |> cast(params, [:email])
    |> validate_required([:email])
    |> update_change(:email, &String.downcase/1)
    |> update_change(:email, &String.trim/1)
    |> unique_constraint(:email, message: "already in use", name: :users_lower_email_index)
    |> validate_format(:email, email_format(), message: "not a valid email address")
  end

  def edit_changeset(model, params \\ %{}) do
    model
    |> cast(params, [:email, :new_password, :new_password_confirmation])
    |> validate_required([:email])
    |> update_change(:email, &String.downcase/1)
    |> update_change(:email, &String.trim/1)
    |> unique_constraint(:email, message: "already in use", name: :users_lower_email_index)
    |> validate_format(:email, email_format(), message: "not a valid email address")
    |> validate_confirmation(:new_password)
    |> hash_password
  end

  defp hash_password(changeset) do
    if password = get_change(changeset, :new_password) do
      changeset
      |> put_change(:password, Bcrypt.hash_pwd_salt(password))
    else
      changeset
    end
  end

  defp validate_current_password(changeset, field) do
    if current_password = get_change(changeset, field) do
      case AppTemplate.Authentication.verify_credentials(changeset.data.email, current_password) do
        {:ok, _user} ->
          changeset

        {:error, :unauthorized} ->
          add_error(changeset, field, "invalid")
      end
    else
      changeset
    end
  end

  def update_password_changeset(model, params \\ %{}) do
    model
    |> cast(
      params,
      [:current_password, :new_password, :new_password_confirmation]
    )
    |> validate_required([
      :current_password,
      :new_password,
      :new_password_confirmation
    ])
    |> validate_current_password(:current_password)
    |> validate_confirmation(:new_password)
    |> hash_password
  end

  def forgot_password_changeset(model, params \\ %{}) do
    model
    |> cast(
      params,
      [:new_password, :new_password_confirmation]
    )
    |> validate_required([
      :new_password,
      :new_password_confirmation
    ])
    |> validate_confirmation(:new_password)
    |> hash_password
  end

  defp email_format do
    ~r/\A[^@]+@[^@]+\z/
  end

  def create_changeset(schema, data) do
    changeset(schema, data)
  end
end
