defmodule MappConstruction.AuthenticationToken do
  @moduledoc """
  Configures behavior of JSON web tokens for authentication
  """
  use Joken.Config
  alias Joken.Signer
  @day_in_seconds 86400
  @expiration_in_days 30
  @expiration_in_seconds @day_in_seconds * @expiration_in_days

  @impl true
  def token_config do
    default_claims(iss: "MappConstruction", aud: "MappConstruction", default_exp: @expiration_in_seconds)
  end

  def signer,
    do: Signer.create("HS256", Application.get_env(:mapp_construction, :jwt_secret, nil))

  def expires_in, do: @expiration_in_seconds
end
