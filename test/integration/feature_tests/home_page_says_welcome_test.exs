defmodule MappConstructionWeb.HomePageSaysWelcomeTest do
  use Cabbage.Feature,
    async: true,
    file: "home_page_says_welcome.feature"
  use MappConstructionWeb.IntegrationCase

  defwhen ~r/^I navigate to the home screen$/, _variables, _state do
    navigate_to("/")
  end

  defthen ~r/^I see a welcome message$/, _variables, _state do
    element = find_element(:tag, "h1")
    assert inner_html(element) == "Welcome"
  end
end
