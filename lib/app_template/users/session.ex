defmodule MappConstruction.Session do
  @moduledoc """
  Defines an embedded schema + changeset for a user session.
  There's no corresponding db table - this is just for use in forms.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias MappConstruction.Session

  embedded_schema do
    field(:email, :string, primary_key: true)
    field(:password, :string)
  end

  def changeset(model \\ %Session{}, params \\ %{}) do
    model
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
  end
end
