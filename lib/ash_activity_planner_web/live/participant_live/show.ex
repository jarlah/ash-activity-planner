defmodule AshActivityPlannerWeb.ParticipantLive.Show do
  use AshActivityPlannerWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Participant <%= @participant.id %>
      <:subtitle>This is a participant record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/participants/#{@participant}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit participant</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Name"><%= @participant.name %></:item>
      <:item title="Phone"><%= @participant.phone %></:item>
      <:item title="Email"><%= @participant.email %></:item>
    </.list>

    <.back navigate={~p"/participants"}>Back to participants</.back>

    <.modal
      :if={@live_action == :edit}
      id="participant-modal"
      show
      on_cancel={JS.patch(~p"/participants/#{@participant}")}
    >
      <.live_component
        module={AshActivityPlannerWeb.ParticipantLive.FormComponent}
        id={@participant.id}
        title={@page_title}
        action={@live_action}
        participant={@participant}
        patch={~p"/participants/#{@participant}"}
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
     |> assign(:participant, AshActivityPlanner.Planner.Participant.by_id!(id))}
  end

  defp page_title(:show), do: "Show Participant"
  defp page_title(:edit), do: "Edit Participant"
end
