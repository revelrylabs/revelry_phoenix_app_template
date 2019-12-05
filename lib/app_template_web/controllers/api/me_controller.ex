defmodule AppTemplateWeb.API.MeController do
  use AppTemplateWeb, :controller

  def show(conn, _params) do
    render(conn, "show.json", user: conn.assigns.current_user)
  end
end
