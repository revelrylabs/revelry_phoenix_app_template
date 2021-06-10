defmodule AppTemplate.Generators do
  @moduledoc """
  Holds generator functions to provide generative data for testing

  For generators offered by StreamData, check here:
  https://hexdocs.pm/stream_data
  """

  use ExUnitProperties

  alias AppTemplate.{
    User
  }

  def generator(:user) do
    gen all(email <- generator(:email)) do
      %User{
        email: email,
        password: Bcrypt.hash_pwd_salt("password")
      }
    end
  end

  def generator(:email) do
    gen all(
          local <- string(:alphanumeric, min_length: 1),
          domain <- string(:alphanumeric, min_length: 1)
        ) do
      String.downcase(local <> to_string(System.unique_integer()) <> "@" <> domain)
    end
  end

  def generate(generator_name, attributes \\ []) do
    1 |> generate_list(generator_name, attributes) |> List.first()
  end

  def generate_list(count, generator_name, attributes \\ []) do
    generator_name
    |> apply_attrs_to_generator(attributes)
    |> Enum.take(count)
  end

  defp apply_attrs_to_generator(generator_name, attributes) do
    generator_name
    |> generator
    |> Stream.map(&struct(&1, attributes))
  end

  def generate_string(max_length) do
    length = Enum.random(1..max_length)

    length |> :crypto.strong_rand_bytes() |> Base.url_encode64() |> binary_part(0, length)
  end
end
