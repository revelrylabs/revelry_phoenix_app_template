defmodule AppTemplate.Factory do
  alias AppTemplate.{User, Repo}
  use ExMachina.Ecto, repo: Repo

  def user_factory do
    %User{
      email: "test#{System.unique_integer([:positive])}@example.com",
      password: "$2b$12$.6tY2BiVPAIhie1Zxh/ePexJ76CXLOycFXqvYlsb8AYfBCHHYhkMq"
    }
  end

  def random_string(max_length) do
    length = Enum.random(1..max_length)

    length |> :crypto.strong_rand_bytes() |> Base.url_encode64() |> binary_part(0, length)
  end
end
