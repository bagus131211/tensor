defmodule ChatterWeb.Router do
  use ChatterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ChatterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.Pipeline, module: Chatter.Guardian, error_handler: Chatter.Token
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChatterWeb do
    pipe_through :browser
    resources "/users", UserController, [:new, :create]
    resources "/sessions", SessionController, only: [:create, :delete]
    get "/", SessionController, :new
  end

  scope "/", ChatterWeb do
    pipe_through [:browser, :browser_auth]
    resources "/users", UserController, only: [:index, :show, :edit, :update, :delete]
    get "/chat", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatterWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:chatter, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ChatterWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
