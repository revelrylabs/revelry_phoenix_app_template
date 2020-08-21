defmodule AppTemplate.Scrubber do
  @moduledoc """
  Module for functions that deal with scrubbing sensitive data.
  """

  @filter_atoms [
    :client_token,
    :access_token,
    :device_token,
    :password,
    :current_password,
    :new_password,
    :new_confirm_password,
    :confirm_password,
    :password_confirmation
  ]

  @filter_strings Enum.map(@filter_atoms, &Atom.to_string/1)

  @doc """
  Scrubs data values to remove sensitive data.

  ## Examples

    iex> scrub(password: "password")
    [password: "[FILTERED]"]

    iex> scrub(%{"thing" => %{"with" => "strings", "creds" => %{"password" =>  "filterme"}}})
    %{"thing" => %{"with" => "strings", "creds" => %{"password" => "[FILTERED]"}}}

    iex> scrub(%{thing: %{in: %{thing: %{password: "asdf"}}}})
    %{thing: %{in: %{thing: %{password: "[FILTERED]"}}}}

    iex> scrub(keyword_list: [%{inside_a_list_of_maps: %{password: "bad"}}])
    [keyword_list: [%{inside_a_list_of_maps: %{password: "[FILTERED]"}}]]

    iex> scrub({[%{password: "test"}]})
    {[%{password: "[FILTERED]"}]}
  """
  def scrub(data) when is_tuple(data) do
    case data do
      {k, _v} when k in @filter_strings or k in @filter_atoms ->
        {k, "[FILTERED]"}

      {k, v} when is_map(v) or is_list(v) ->
        {k, scrub(v)}

      _ ->
        data |> Tuple.to_list() |> scrub() |> List.to_tuple()
    end
  end

  def scrub(%{__struct__: _} = data), do: data |> Map.from_struct() |> scrub()
  def scrub(data) when is_list(data), do: Enum.map(data, &scrub/1)
  def scrub(data) when is_map(data), do: Enum.into(data, %{}, &scrub/1)
  def scrub(other), do: other
end
