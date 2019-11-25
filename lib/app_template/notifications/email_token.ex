defmodule MappConstruction.EmailToken do
  @moduledoc """
  Configures behavior of JSON web tokens for emails
  """
  use Joken.Config
  alias Joken.Signer

  @impl true
  def token_config do
    default_claims(iss: "MappConstruction", aud: "MappConstruction")
  end

  def signer,
    do: Signer.create("HS256", Application.get_env(:mapp_construction, :jwt_secret, nil))
end
