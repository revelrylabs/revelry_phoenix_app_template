defmodule AppTemplateWeb.PowResetPassword.MailerView do
  use AppTemplateWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end
