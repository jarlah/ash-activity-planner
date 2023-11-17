defmodule AshActivityPlannerWeb.ParticipantLive.Show do
  use AshActivityPlannerWeb, :live_view

  alias AshActivityPlanner.Planner.Participant

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:participant, Participant.by_id!(id))}
  end

  defp page_title(:show), do: "Show Participant"
  defp page_title(:edit), do: "Edit Participant"
end
