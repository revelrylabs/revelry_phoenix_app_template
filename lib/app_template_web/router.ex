defmodule AppTemplateWeb.Router do
  use AppTemplateWeb, :router
  alias AppTemplateWeb.{RequireAuth, LoadUser}

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug LoadUser
  end

  pipeline :require_auth do
    plug RequireAuth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AppTemplateWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/sessions/new", SessionController, :new
    post "/sessions/new", SessionController, :create
  end

  scope "/", AppTemplateWeb do
    pipe_through [:browser, :require_auth]

    get "/sessions/delete", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppTemplateWeb do
  #   pipe_through :api
  # end
end
