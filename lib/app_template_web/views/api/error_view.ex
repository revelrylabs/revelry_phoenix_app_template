defmodule AppTemplateWeb.API.ErrorView do
  use AppTemplateWeb, :view
  alias Plug.Conn.Status
  alias Ecto.Changeset

  def render("422.json", %{changeset: %Changeset{} = changeset}) do
    errors =
      Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn
          {:type, {:array, :map}}, acc ->
            acc

          {key, value}, acc ->
            String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    %{errors: errors}
  end

  def render("422.json", %{errors: errors}) do
    %{errors: errors}
  end

  def render(<<status::binary-size(3), ".json">>, _assigns) do
    {int_status, _} = Integer.parse(status)

    %{
      errors: %{
        http: ["#{int_status}: #{Status.reason_phrase(int_status)}"]
      }
    }
  end
end
