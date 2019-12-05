defmodule AppTemplateWeb.API.MeView do
  use AppTemplateWeb, :view

  def render("show.json", %{user: user}) do
    %{
      data: %{
        id: user.id,
        email: user.email
      }
    }
  end
end
