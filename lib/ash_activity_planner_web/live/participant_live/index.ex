defmodule AshActivityPlannerWeb.ParticipantLive.Index do
  use AshActivityPlannerWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Participants
      <:actions>
        <.link patch={~p"/participants/new"}>
          <.button>New Participant</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="participants"
      rows={@streams.participants}
      row_click={fn {_id, participant} -> JS.navigate(~p"/participants/#{participant}") end}
    >
      <:col :let={{_id, participant}} label="Id"><%= participant.id %></:col>

      <:col :let={{_id, participant}} label="Email"><%= participant.email %></:col>

      <:col :let={{_id, participant}} label="Name"><%= participant.name %></:col>

      <:col :let={{_id, participant}} label="Phone"><%= participant.phone %></:col>

      <:col :let={{_id, participant}} label="Description"><%= participant.description %></:col>

      <:action :let={{_id, participant}}>
        <div class="sr-only">
          <.link navigate={~p"/participants/#{participant}"}>Show</.link>
        </div>

        <.link patch={~p"/participants/#{participant}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, participant}}>
        <.link
          phx-click={JS.push("delete", value: %{id: participant.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="participant-modal"
      show
      on_cancel={JS.patch(~p"/participants")}
    >
      <.live_component
        module={AshActivityPlannerWeb.ParticipantLive.FormComponent}
        id={(@participant && @participant.id) || :new}
        title={@page_title}
        action={@live_action}
        participant={@participant}
        patch={~p"/participants"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     stream(
       socket,
       :participants,
       AshActivityPlanner.Planner.read!(AshActivityPlanner.Planner.Participant)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Participant")
    |> assign(:participant, AshActivityPlanner.Planner.Participant.by_id!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Participant")
    |> assign(:participant, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Participants")
    |> assign(:participant, nil)
  end

  @impl true
  def handle_info(
        {AshActivityPlannerWeb.ParticipantLive.FormComponent, {:saved, participant}},
        socket
      ) do
    {:noreply, stream_insert(socket, :participants, participant)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    participant = AshActivityPlanner.Planner.Participant.by_id!(id)
    AshActivityPlanner.Planner.destroy!(participant)

    {:noreply, stream_delete(socket, :participants, participant)}
  end
end
