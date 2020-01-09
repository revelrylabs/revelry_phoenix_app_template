defmodule AppTemplateWeb.API.RegistrationView do
  use AppTemplateWeb, :view

  def render("new.json", %{token: token}) do
    %{
      data: %{
        token: token
      }
    }
  end
end
