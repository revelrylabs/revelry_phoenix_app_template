defmodule AppTemplate.EmailBuilder do
  @moduledoc """
  Handles building emails via the appropriate template and assigned data
  https://hexdocs.pm/bamboo/readme.html#getting-started
  """
  import Bamboo.Email
  use Bamboo.Phoenix, view: AppTemplateWeb.EmailView
  alias AppTemplate.EmailToken

  def welcome_email(user) do
    claims = user |> Map.from_struct() |> Map.take([:email])
    {:ok, token, _} = EmailToken.generate_and_sign(claims, EmailToken.signer())

    confirmation_url =
      AppTemplateWeb.Router.Helpers.email_verification_url(AppTemplateWeb.Endpoint, :verify,
        token: token
      )

    base_email()
    |> assign(:user, user)
    |> assign(:url, confirmation_url)
    |> to(user.email)
    |> subject("Welcome to AppTemplate!")
    |> render("welcome.html")
  end

  def build_email_password_reset(user) do
    claims = Map.merge(%{user_id: user.id}, %{"aud" => "AppTemplate", "iss" => "AppTemplate"})
    {:ok, token, _} = EmailToken.generate_and_sign(claims, EmailToken.signer())

    change_password_url =
      AppTemplateWeb.Router.Helpers.forgot_password_url(
        AppTemplateWeb.Endpoint,
        :edit,
        user.id,
        token: token
      )

    base_email()
    |> to(user.email)
    |> assign(:user, user)
    |> assign(:url, change_password_url)
    |> subject("AppTemplate Reset Password")
    |> render("forgot_password.html")
  end

  def build_password_changed_email(user) do
    base_email()
    |> to(user.email)
    |> assign(:user, user)
    |> subject("AppTemplate Password Changed")
    |> render("password_changed.html")
  end

  defp base_email do
    new_email()
    |> from({"AppTemplate", "noreply@app_template.org"})
    |> put_html_layout({AppTemplateWeb.LayoutView, "email.html"})
  end
end
