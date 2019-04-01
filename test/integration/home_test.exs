defmodule AppTemplateWeb.HomePageTest do
  use AppTemplateWeb.FeatureCase, async: true

  import Wallaby.Query

  test "Home Page says welcome", %{session: session} do
    session
    |> visit("/")
    |> assert_has(xpath(".//h1", text: "Welcome"))
  end
end
