defmodule AppTemplate.Factory do
  alias AppTemplate.{Repo}
  use ExMachina.Ecto, repo: Repo
  alias AppTemplate.Generators

  def user_factory do
    Generators.generate(:user)
  end
end
