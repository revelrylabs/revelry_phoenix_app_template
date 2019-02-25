defmodule AppTemplate.EmailToken do
  @moduledoc """
  Configures behavior of JSON web tokens for emails
  """
  use Joken.Config
  alias Joken.Signer

  @impl true
  def token_config do
    default_claims(iss: "AppTemplate", aud: "AppTemplate")
  end

  def signer,
    do: Signer.create("HS256", Application.get_env(:app_template, :jwt_secret, nil))
end
