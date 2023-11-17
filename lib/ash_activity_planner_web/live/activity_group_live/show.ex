defmodule AshActivityPlannerWeb.ActivityGroupLive.Show do
  use AshActivityPlannerWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Activity group <%= @activity_group.id %>
      <:subtitle>This is a activity_group record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/activity_groups/#{@activity_group}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit activity_group</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Title"><%= @activity_group.title %></:item>
      <:item title="Description"><%= @activity_group.description %></:item>
    </.list>

    <.back navigate={~p"/activity_groups"}>Back to activity_groups</.back>

    <.modal
      :if={@live_action == :edit}
      id="activity_group-modal"
      show
      on_cancel={JS.patch(~p"/activity_groups/#{@activity_group}")}
    >
      <.live_component
        module={AshActivityPlannerWeb.ActivityGroupLive.FormComponent}
        id={@activity_group.id}
        title={@page_title}
        action={@live_action}
        activity_group={@activity_group}
        patch={~p"/activity_groups/#{@activity_group}"}
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
     |> assign(:activity_group, AshActivityPlanner.Planner.ActivityGroup.by_id!(id))}
  end

  defp page_title(:show), do: "Show Activity group"
  defp page_title(:edit), do: "Edit Activity group"
end
