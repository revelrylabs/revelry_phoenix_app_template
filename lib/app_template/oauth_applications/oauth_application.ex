defmodule AppTemplate.OauthApplications.OauthApplication do
  use Ecto.Schema
  use ExOauth2Provider.Applications.Application, otp_app: :app_template

  schema "oauth_applications" do
    application_fields()

    timestamps()
  end
end
