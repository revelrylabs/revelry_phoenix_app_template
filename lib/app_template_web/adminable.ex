defprotocol AppTemplateWeb.Adminable do
  def readable_fields(schema)
  def editable_fields(schema)
  def index_fields(schema)
end

defimpl AppTemplateWeb.Adminable, for: AppTemplate.User do
  @readable [:id, :inserted_at, :updated_at]
  @editable [:email, :admin, :email_verified]

  def readable_fields(_s), do: @readable ++ @editable
  def editable_fields(_s), do: @editable
  def index_fields(s), do: readable_fields(s)
end
