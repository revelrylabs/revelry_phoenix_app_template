defmodule AppTemplateWeb.Router do
  use AppTemplateWeb, :router
  use Plug.ErrorHandler
  alias AppTemplateWeb.{RequireAuthentication, LoadUser, RequireAnonymous}

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

  pipeline :require_authoritzation do
    plug RequireAuthentication
  end

  pipeline :require_anonymous do
    plug RequireAnonymous
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AppTemplateWeb do
    # Use the default browser stack
    pipe_through [:browser]
    get "/", PageController, :index
    get "/styleguide", PageController, :styleguide
    get "/email/verify", EmailVerificationController, :verify
  end

  scope "/", AppTemplateWeb do
    pipe_through [:browser, :require_anonymous]

    get "/register", UserController, :new
    post "/register", UserController, :create

    get "/sessions/new", SessionController, :new
    post "/sessions/new", SessionController, :create
  end

  scope "/", AppTemplateWeb do
    pipe_through [:browser, :require_authoritzation]

    get "/sessions/delete", SessionController, :delete
  end

  scope "/admin", AppTemplateWeb do
    pipe_through [:browser, :require_authoritzation]

    get("/:schema/", AdminController, :index)
    get("/new/:schema", AdminController, :new)
    post("/new/:schema", AdminController, :create)
    get("/edit/:schema/:pk", AdminController, :edit)
    put("/update/:schema/:pk", AdminController, :update)
  end

  scope "/images", AppTemplateWeb do
    pipe_through([:browser, :require_authoritzation])

    forward("/sign", Transmit, signer: Transmit.S3Signer, bucket: "app_template", path: "uploads")
  end

  scope "/api", AppTemplateWeb.API, as: :api do
    pipe_through [:browser, :require_anonymous]

    post("/authenticate", AuthenticationController, :authenticate)
  end

  scope "/api", AppTemplateWeb.API, as: :api do
    pipe_through [:browser, :require_authoritzation]
  end
end
