defmodule AppTemplateWeb.RequireAuth do
  @moduledoc """
  Ensures user is logged in
  """

  import Plug.Conn
  alias AppTemplateWeb.Router.Helpers, as: Routes

  def init(opts) do
    opts
  end

  def call(%Plug.Conn{assigns: %{current_user: nil}} = conn, _) do
    path = "#{conn.request_path}?#{conn.query_string}"
    encoded_path = URI.encode_www_form(path)
    to_path = Routes.session_path(conn, :new, next: encoded_path)

    conn
    |> Phoenix.Controller.redirect(to: to_path)
    |> halt()
  end

  def call(conn, _), do: conn
end
