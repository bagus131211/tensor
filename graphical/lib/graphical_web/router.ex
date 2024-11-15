defmodule GraphicalWeb.Router do
  use GraphicalWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug GraphicalWeb.Plug.Context
  end

  scope "/", GraphicalWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    resources "/posts", PostController, except: [:new, :edit]
  end

  scope "/api" do
    pipe_through :graphql

    forward "/", Absinthe.Plug,
      schema: GraphicalWeb.Schema,
      context: %{
        loader: Dataloader.new()
      }
  end

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: GraphicalWeb.Schema,
    context: %{
      loader: Dataloader.new()
    }

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:graphical, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: GraphicalWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
