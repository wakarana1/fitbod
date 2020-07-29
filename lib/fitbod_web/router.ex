defmodule FitbodAppWeb.Router do
  use FitbodAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FitbodAppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :api_auth do
    plug :ensure_authenticated
  end

  scope "/", FitbodAppWeb do
    pipe_through :browser

    get "/", UserWebController, :index

    resources "/users", UserWebController do
      resources "/workouts", WorkoutWebController
    end
  end

  # Other scopes may use custom stacks.
  scope "/api", FitbodAppWeb do
    pipe_through :api
    post "/users/sign_up", UserController, :create
    post "/users/sign_in", UserController, :sign_in
  end

  scope "/api", FitbodAppWeb do
    pipe_through [:api, :api_auth]

    resources "/users", UserController, except: [:new, :edit] do
      resources "/workouts", WorkoutController
    end
  end

  defp ensure_authenticated(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)

    if current_user_id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(FitbodAppWeb.ErrorView)
      |> render("401.json", message: "Unauthenticated user")
      |> halt()
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: FitbodAppWeb.Telemetry
    end
  end
end
