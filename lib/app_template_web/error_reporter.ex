defmodule AppTemplateWeb.ErrorReporter do
  @moduledoc """
  Takes care of reporting router errors.
  """
  alias Plug.Conn

  @filtered_params [
    "current_password",
    "new_password",
    "new_confirm_password",
    "password",
    "confirm_password"
  ]
  @ignore_error_routes [
    "/wp-login.php",
    "/favicon.ico"
  ]

  # ignore errors for paths that have no reason to exist
  def handle_errors(%{request_path: request_path}, _)
      when request_path in @ignore_error_routes do
    nil
  end

  def handle_errors(conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    conn =
      conn
      |> Conn.fetch_cookies()
      |> Conn.fetch_query_params()

    conn_data = %{
      "request" => %{
        "cookies" => conn.req_cookies,
        "url" => "#{conn.scheme}://#{conn.host}:#{conn.port}#{conn.request_path}",
        "user_ip" => conn.remote_ip |> Tuple.to_list() |> Enum.join("."),
        "headers" => Enum.into(conn.req_headers, %{}),
        "params" => sanitize(conn.params),
        "method" => conn.method
      }
    }

    conn_data =
      case conn do
        %{assigns: %{current_user: %{id: id, email: email}}} ->
          conn_data
          |> Map.put("person", %{
            "id" => to_string(id),
            "email" => email
          })

        _ ->
          conn_data
      end

    Rollbax.report(kind, reason, stacktrace, %{}, conn_data)
  end

  def sanitize(data) do
    for {key, value} <- data, into: %{} do
      sanitize(key, value)
    end
  end

  defp sanitize(key, value) when is_map(value) do
    {key, sanitize(value)}
  end

  defp sanitize(key, value) do
    if key in @filtered_params do
      {key, "[FILTERED]"}
    else
      {key, value}
    end
  end
end
