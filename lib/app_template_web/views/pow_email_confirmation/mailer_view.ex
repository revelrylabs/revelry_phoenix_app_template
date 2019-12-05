defmodule AppTemplateWeb.PowEmailConfirmation.MailerView do
  use AppTemplateWeb, :mailer_view

  def subject(:email_confirmation, _assigns), do: "Confirm your email address"
end
