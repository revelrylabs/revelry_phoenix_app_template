defmodule AppTemplate.Factory do
  alias AppTemplate.{Repo, APIKey}
  use ExMachina.Ecto, repo: Repo
  alias AppTemplate.Generators

  def user_factory do
    Generators.generate(:user)
  end

  def api_key_factory do
    %APIKey{
      user: build(:user),
      prefix: sequence(:prefix, &"app_template.#{&1}"),
      key_hash: Bcrypt.hash_pwd_salt("test")
    }
  end
end
