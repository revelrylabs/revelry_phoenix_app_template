defmodule AppTemplateWeb.Router do
  use AppTemplateWeb, :router
  use Plug.ErrorHandler
  alias AppTemplateWeb.{RequireAuth, LoadUser, RequireUnauth}

  defp handle_errors(conn, error_data) do
    AppTemplateWeb.ErrorReporter.handle_errors(conn, error_data)
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

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

  pipeline :require_unauth do
    plug RequireUnauth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AppTemplateWeb do
    # Use the default browser stack
    pipe_through [:browser]
    get "/", PageController, :index
    get "/styleguide", PageController, :styleguide
  end

  scope "/", AppTemplateWeb do
    pipe_through [:browser, :unauthenticated]

    get "/register", UserController, :new
    post "/register", UserController, :create

    get "/sessions/new", SessionController, :new
    post "/sessions/new", SessionController, :create
  end

  scope "/", AppTemplateWeb do
    pipe_through [:browser, :require_auth]

    get "/sessions/delete", SessionController, :delete
  end

  scope "/images", AppTemplateWeb do
    pipe_through([:browser, :require_auth])

    get("/sign", S3Controller, :sign)
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppTemplateWeb do
  #   pipe_through :api
  # end
end
