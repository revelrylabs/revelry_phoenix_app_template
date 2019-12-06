defmodule AppTemplateWeb.ErrorViewTest do
  use AppTemplateWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(AppTemplateWeb.ErrorView, "404.html", []) ==
             "Not Found"
  end

  test "render 500.html" do
    assert render_to_string(AppTemplateWeb.ErrorView, "500.html", []) ==
             "Internal Server Error"
  end

  test "render any other" do
    assert render_to_string(AppTemplateWeb.ErrorView, "505.html", []) ==
             "Internal Server Error"
  end
end
