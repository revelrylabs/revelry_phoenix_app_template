defmodule AppTemplateWeb.Router do
  use AppTemplateWeb, :router
  use Pow.Phoenix.Router

  use Pow.Extension.Phoenix.Router,
    extensions: [PowResetPassword, PowEmailConfirmation]

  use PhoenixOauth2Provider.Router, otp_app: :app_template

  use Plug.ErrorHandler

  alias AppTemplateWeb.{
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
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AppDomainRedirect
    plug BrowserAuthentication, otp_app: :app_template
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_ensure_authenticated do
    plug ExOauth2Provider.Plug.EnsureAuthenticated
  end

  pipeline :api_proctected do
    plug ExOauth2Provider.Plug.EnsureScopes,
      scopes: ~w(read write)
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

  scope "/" do
    pipe_through [:browser, :protected]

    oauth_routes()
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

  scope "/api" do
    pipe_through [:api]

    oauth_api_routes()
  end

  scope "/api", AppTemplateWeb.API, as: :api do
    pipe_through [:api, :api_ensure_authenticated]
  end

  scope "/api", AppTemplateWeb.API, as: :api do
    pipe_through [:api, :api_ensure_authenticated, :api_proctected]

    get "/user", MeController, :show
  end
end
