defmodule AppTemplateWeb.HomePageTest do
  use AppTemplateWeb.FeatureCase, async: true

  @tag :integration
  test "Home Page says welcome" do
    navigate_to("/")

    element = find_element(:tag, "h1")
    assert inner_html(element) == "Welcome"
  end
end
