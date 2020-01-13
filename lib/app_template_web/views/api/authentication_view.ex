defmodule AppTemplateWeb.API.AuthenticationView do
  use AppTemplateWeb, :view

  def render("new.json", %{token: token}) do
    %{
      data: %{
        token: token
      }
    }
  end

  def render("show.json", %{}) do
    %{
      data: %{}
    }
  end
end
