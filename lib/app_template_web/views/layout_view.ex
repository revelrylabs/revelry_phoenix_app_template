defmodule AppTemplateWeb.LayoutView do
  use AppTemplateWeb, :view

  @spec init_js_module(atom(), binary()) :: binary | {:safe, binary()}
  def init_js_module(view, template)

  # def init_js_module(AppTemplateView, "index.html") do
  #  module("Index")
  # end

  def init_js_module(_view_module, _view_template) do
    "null"
  end

  defp module(module) do
    {:safe, "'#{module}'"}
  end
end
