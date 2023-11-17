defmodule AshActivityPlannerWeb.ActivityLive.Show do
  use AshActivityPlannerWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Activity <%= @activity.id %>
      <:subtitle>This is a activity record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/activities/#{@activity}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit activity</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Title"><%= @activity.title %></:item>
      <:item title="Description"><%= @activity.description %></:item>
      <:item title="Start time"><%= @activity.start_time %></:item>
      <:item title="End time"><%= @activity.end_time %></:item>
    </.list>

    <.back navigate={~p"/activities"}>Back to activities</.back>

    <.modal
      :if={@live_action == :edit}
      id="activity-modal"
      show
      on_cancel={JS.patch(~p"/activities/#{@activity}")}
    >
      <.live_component
        module={AshActivityPlannerWeb.ActivityLive.FormComponent}
        id={@activity.id}
        title={@page_title}
        action={@live_action}
        activity={@activity}
        patch={~p"/activities/#{@activity}"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:activity, AshActivityPlanner.Planner.Activity.by_id!(id))}
  end

  defp page_title(:show), do: "Show Activity"
  defp page_title(:edit), do: "Edit Activity"
end
