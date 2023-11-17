defmodule AshActivityPlannerWeb.ActivityGroupLive.Index do
  use AshActivityPlannerWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Activity groups
      <:actions>
        <.link patch={~p"/activity_groups/new"}>
          <.button>New Activity group</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="activity_groups"
      rows={@streams.activity_groups}
      row_click={fn {_id, activity_group} -> JS.navigate(~p"/activity_groups/#{activity_group}") end}
    >
      <:col :let={{_id, activity_group}} label="Id"><%= activity_group.id %></:col>

      <:col :let={{_id, activity_group}} label="Title"><%= activity_group.title %></:col>

      <:col :let={{_id, activity_group}} label="Description"><%= activity_group.description %></:col>

      <:action :let={{_id, activity_group}}>
        <div class="sr-only">
          <.link navigate={~p"/activity_groups/#{activity_group}"}>Show</.link>
        </div>

        <.link patch={~p"/activity_groups/#{activity_group}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, activity_group}}>
        <.link
          phx-click={JS.push("delete", value: %{id: activity_group.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="activity_group-modal"
      show
      on_cancel={JS.patch(~p"/activity_groups")}
    >
      <.live_component
        module={AshActivityPlannerWeb.ActivityGroupLive.FormComponent}
        id={(@activity_group && @activity_group.id) || :new}
        title={@page_title}
        action={@live_action}
        activity_group={@activity_group}
        patch={~p"/activity_groups"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     stream(
       socket,
       :activity_groups,
       AshActivityPlanner.Planner.read!(AshActivityPlanner.Planner.ActivityGroup)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Activity group")
    |> assign(:activity_group, AshActivityPlanner.Planner.ActivityGroup.by_id!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Activity group")
    |> assign(:activity_group, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Activity groups")
    |> assign(:activity_group, nil)
  end

  @impl true
  def handle_info(
        {AshActivityPlannerWeb.ActivityGroupLive.FormComponent, {:saved, activity_group}},
        socket
      ) do
    {:noreply, stream_insert(socket, :activity_groups, activity_group)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity_group = AshActivityPlanner.Planner.ActivityGroup.by_id!(id)
    AshActivityPlanner.Planner.destroy!(activity_group)

    {:noreply, stream_delete(socket, :activity_groups, activity_group)}
  end
end
