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

  defp base_email do
    new_email()
    |> from({"AppTemplate", "noreply@app_template.org"})
    |> put_html_layout({AppTemplateWeb.LayoutView, "email.html"})
  end
end
