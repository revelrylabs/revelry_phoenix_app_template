defmodule AppTemplate.EmailBuilder do
  @moduledoc """
  Handles building emails via the appropriate template and assigned data
  https://hexdocs.pm/bamboo/readme.html#getting-started
  """
  import Bamboo.Email
  use Bamboo.Phoenix, view: AppTemplateWeb.EmailView

  def welcome_email(user) do
    base_email()
    |> assign(:user, user)
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
