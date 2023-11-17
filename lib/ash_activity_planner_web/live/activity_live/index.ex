defmodule AshActivityPlannerWeb.ActivityLive.Index do
  use AshActivityPlannerWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Activities
      <:actions>
        <.link patch={~p"/activities/new"}>
          <.button>New Activity</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="activities"
      rows={@streams.activities}
      row_click={fn {_id, activity} -> JS.navigate(~p"/activities/#{activity}") end}
    >
      <:col :let={{_id, activity}} label="Id"><%= activity.id %></:col>

      <:col :let={{_id, activity}} label="Title"><%= activity.title %></:col>

      <:col :let={{_id, activity}} label="Description"><%= activity.description %></:col>

      <:col :let={{_id, activity}} label="Start time"><%= activity.start_time %></:col>

      <:col :let={{_id, activity}} label="End time"><%= activity.end_time %></:col>

      <:col :let={{_id, activity}} label="Activity group"><%= activity.activity_group_id %></:col>

      <:action :let={{_id, activity}}>
        <div class="sr-only">
          <.link navigate={~p"/activities/#{activity}"}>Show</.link>
        </div>

        <.link patch={~p"/activities/#{activity}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, activity}}>
        <.link
          phx-click={JS.push("delete", value: %{id: activity.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="activity-modal"
      show
      on_cancel={JS.patch(~p"/activities")}
    >
      <.live_component
        module={AshActivityPlannerWeb.ActivityLive.FormComponent}
        id={(@activity && @activity.id) || :new}
        title={@page_title}
        action={@live_action}
        activity={@activity}
        patch={~p"/activities"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     stream(
       socket,
       :activities,
       AshActivityPlanner.Planner.read!(AshActivityPlanner.Planner.Activity)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Activity")
    |> assign(:activity, AshActivityPlanner.Planner.Activity.by_id!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Activity")
    |> assign(:activity, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Activities")
    |> assign(:activity, nil)
  end

  @impl true
  def handle_info({AshActivityPlannerWeb.ActivityLive.FormComponent, {:saved, activity}}, socket) do
    {:noreply, stream_insert(socket, :activities, activity)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity = AshActivityPlanner.Planner.Activity.by_id!(id)
    AshActivityPlanner.Planner.destroy!(activity)

    {:noreply, stream_delete(socket, :activities, activity)}
  end
end
