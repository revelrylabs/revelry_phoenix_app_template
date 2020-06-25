defmodule AppTemplate.RollbaxReporterTest do
  use AppTemplate.DataCase, async: true
  alias AppTemplate.RollbaxReporter

  defp run(data) do
    data = [:name, :starter, :function, data, :reason]

    :error
    |> RollbaxReporter.handle_event({:pid, '** Task ', data})
    |> Map.get(:custom)
    |> Map.get("arguments")
  end

  test "scrubs fields example one" do
    assert run(password: "password") =~ "[password: \"[FILTERED]\"]"
  end

  test "scrubs fields example two" do
    assert run(%{thing: %{in: %{thing: %{password: "asdf"}}}}) =~
             "[password: \"[FILTERED]\"]"
  end

  test "scrubs fields example three" do
    assert run(keyword_list: [%{inside_a_list_of_maps: [password: "bad"]}]) =~
             "[password: \"[FILTERED]\"]"
  end

  test "scrubs fields example four" do
    assert run({[%{password: "test"}]}) =~ "[password: \"[FILTERED]\"]"
  end
end
