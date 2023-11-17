defmodule AshActivityPlannerWeb.Router do
  use AshActivityPlannerWeb, :router
  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AshActivityPlannerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
  end

  scope "/", AshActivityPlannerWeb do
    pipe_through :browser

    ash_authentication_live_session :authentication_not_required,
      on_mount: {AshActivityPlannerWeb.LiveUserAuth, :live_user_optional} do
      live "/", HomeLive, :index
    end

    sign_in_route(register_path: "/register", reset_path: "/reset")
    sign_out_route AuthController
    auth_routes_for AshActivityPlanner.Accounts.User, to: AuthController
    reset_route []
  end

  ash_authentication_live_session :authentication_required,
    on_mount: {AshActivityPlannerWeb.LiveUserAuth, :live_user_required} do
    scope "/", AshActivityPlannerWeb do
      pipe_through [:browser]

      live "/participants", ParticipantLive.Index, :index
      live "/participants/new", ParticipantLive.Index, :new
      live "/participants/:id/edit", ParticipantLive.Index, :edit
      live "/participants/:id", ParticipantLive.Show, :show
      live "/participants/:id/show/edit", ParticipantLive.Show, :edit

      live "/activity_groups", ActivityGroupLive.Index, :index
      live "/activity_groups/new", ActivityGroupLive.Index, :new
      live "/activity_groups/:id/edit", ActivityGroupLive.Index, :edit
      live "/activity_groups/:id", ActivityGroupLive.Show, :show
      live "/activity_groups/:id/show/edit", ActivityGroupLive.Show, :edit

      live "/activities", ActivityLive.Index, :index
      live "/activities/new", ActivityLive.Index, :new
      live "/activities/:id/edit", ActivityLive.Index, :edit
      live "/activities/:id", ActivityLive.Show, :show
      live "/activities/:id/show/edit", ActivityLive.Show, :edit
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", AshActivityPlannerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ash_activity_planner, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AshActivityPlannerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
