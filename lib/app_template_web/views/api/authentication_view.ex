defmodule MappConstructionWeb.API.AuthenticationView do
  use MappConstructionWeb, :view

  def render("show.json", %{token: %{user: user, access_token: access_token, expires_in: expires}}) do
    %{
      data: %{
        id: user.id,
        type: "token",
        attributes: %{
          access_token: access_token,
          token_type: "Bearer",
          expires_in: expires
        }
      }
    }
  end
end
