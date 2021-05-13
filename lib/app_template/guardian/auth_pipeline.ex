defmodule AppTemplate.Guardian.Pipeline do
  @moduledoc """
  Configures a set of plugs to be used with Guardian based authentication
  """
  use Guardian.Plug.Pipeline,
    otp_app: :hunit_platform,
    error_handler: AppTemplate.Guardian.ErrorHandler,
    module: AppTemplate.Guardian

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
