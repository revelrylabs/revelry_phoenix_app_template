defmodule AppTemplateWeb.RequireAuth do
  @moduledoc """
  Ensures user is logged in
  """

  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _) do
    case conn.assigns.current_user do
      nil ->
        conn
        |> send_resp(403, "Unauthorized")
        |> halt()
      _user ->
        conn
    end
  end
end
