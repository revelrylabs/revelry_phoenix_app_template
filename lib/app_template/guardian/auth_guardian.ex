defmodule AppTemplate.Guardian do
  @moduledoc """
  Guardian module used for decoding auth0 token. Overwrites the default This file is a dependency for Guardian configuration.
  """
  use Guardian, otp_app: :app_template

  def log_in(conn, user) do
    __MODULE__.Plug.sign_in(conn, user)
  end

  @doc """
  Fetches the subject for a token for the provided resource and claims The subject should be a short identifier that can be used to identify the resource
  """
  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  @doc """
  Fetches the resource that is represented by claims.
  """
  def resource_from_claims(%{"sub" => sub}) do
    {:ok, sub}
  end
end
