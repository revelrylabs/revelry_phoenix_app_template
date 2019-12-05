defmodule AppTemplate.Mailer do
  @moduledoc """
  AppTemplate mailer
  """
  use Bamboo.Mailer, otp_app: :app_template
  use Pow.Phoenix.Mailer

  import Bamboo.Email

  def cast(%{user: user, subject: subject, text: text, html: html}) do
    new_email(
      to: user.email,
      from: Application.get_env(:app_template, :email),
      subject: subject,
      html_body: html,
      text_body: text
    )
  end

  def process(email) do
    deliver_now(email)
  end
end
