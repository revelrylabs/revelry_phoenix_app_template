defmodule AppTemplate.APIKey do
  use Ecto.Schema
  alias AppTemplate.User
  import Ecto.{Query, Changeset}, warn: false
  import AppTemplateWeb.Gettext, only: [gettext: 1]

  @type t :: %__MODULE__{}
  schema "api_keys" do
    belongs_to(:user, User)
    field(:name, :string)
    field(:prefix, :string)
    field(:key, :string, virtual: true)
    field(:key_hash, :string)
    timestamps()
  end

  def create_changeset(model, attrs \\ %{}) do
    model
    |> cast(attrs, [:user_id, :name])
    |> validate_required([:user_id, :name])
    |> unique_constraint(:name,
      message: gettext("already in use"),
      name: :api_keys_user_id_lower_name_index
    )
    |> generate_client_and_secret
  end

  def update_changeset(model, attrs \\ %{}) do
    model
    |> cast(attrs, [:user_id, :name])
    |> validate_required([
      :user_id,
      :name
    ])
    |> unique_constraint(:name,
      message: gettext("already in use"),
      name: :api_keys_user_id_lower_name_index
    )
  end

  defp generate_client_and_secret(changeset) do
    prefix = "app_template." <> random_string(8)
    key = random_string(16)
    key_hash = Bcrypt.hash_pwd_salt(key)

    changeset
    |> put_change(:prefix, prefix)
    |> put_change(:key, key)
    |> put_change(:key_hash, key_hash)
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end
end
