defmodule AppTemplateWeb.Router do
  use AppTemplateWeb, :router
  use Pow.Phoenix.Router
  import Phoenix.LiveDashboard.Router

  use Pow.Extension.Phoenix.Router,
    extensions: [PowResetPassword, PowEmailConfirmation]

  use Plug.ErrorHandler

  alias AppTemplateWeb.{
    APIAuthentication,
    AppDomainRedirect,
    BrowserAuthentication,
    RequirePermission
  }

  defp handle_errors(conn, error_data) do
    AppTemplateWeb.ErrorReporter.handle_errors(conn, error_data)
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {AppTemplateWeb.LayoutView, :root}
    plug AppDomainRedirect
    plug BrowserAuthentication, otp_app: :app_template
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug APIAuthentication, otp_app: :app_template
  end

  pipeline :require_admin do
    plug RequirePermission, permission: :administrator
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :anonymous do
    plug Pow.Plug.RequireNotAuthenticated, error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_extension_routes()
  end

  scope "/", AppTemplateWeb do
    # Use the default browser stack
    pipe_through [:browser]
    get "/", PageController, :index
    get "/styleguide", PageController, :styleguide
  end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AppTemplate.Telemetry
    end
  end

  scope "/admin" do
    pipe_through [:browser, :protected, :require_admin]

    forward("/", Adminable.Plug,
      otp_app: :app_template,
      repo: AppTemplate.Repo,
      schemas: [AppTemplate.User],
      layout: {AppTemplateWeb.LayoutView, "app.html"}
    )
  end

  scope "/images" do
    pipe_through([:browser, :protected])

    forward("/sign", Transmit,
      signer: Transmit.S3Signer,
      bucket: "app-template",
      path: "uploads"
    )
  end

  scope "/api", AppTemplateWeb.API, as: :api do
    pipe_through [:api]

    get "/", MeController, :show
  end
end
