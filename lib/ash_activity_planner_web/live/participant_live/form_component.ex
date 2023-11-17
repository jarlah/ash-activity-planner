defmodule AshActivityPlannerWeb.ParticipantLive.FormComponent do
  use AshActivityPlannerWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage participant records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="participant-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <%= if @form.source.type == :create do %>
          <.input field={@form[:activities]} type="select" multiple label="Activities" options={[]} />
          <.input field={@form[:id]} type="text" label="Id" /><.input
            field={@form[:email]}
            type="text"
            label="Email"
          /><.input field={@form[:name]} type="text" label="Name" /><.input
            field={@form[:phone]}
            type="text"
            label="Phone"
          /><.input field={@form[:description]} type="text" label="Description" />
        <% end %>
        <%= if @form.source.type == :update do %>
          <.input field={@form[:id]} type="text" label="Id" /><.input
            field={@form[:email]}
            type="text"
            label="Email"
          /><.input field={@form[:name]} type="text" label="Name" /><.input
            field={@form[:phone]}
            type="text"
            label="Phone"
          /><.input field={@form[:description]} type="text" label="Description" />
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving...">Save Participant</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", %{"participant" => participant_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, participant_params))}
  end

  def handle_event("save", %{"participant" => participant_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: participant_params) do
      {:ok, participant} ->
        notify_parent({:saved, participant})

        socket =
          socket
          |> put_flash(:info, "Participant #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{participant: participant}} = socket) do
    form =
      if participant do
        AshPhoenix.Form.for_update(participant, :update,
          api: AshActivityPlanner.Planner,
          as: "participant"
        )
      else
        AshPhoenix.Form.for_create(AshActivityPlanner.Planner.Participant, :create,
          api: AshActivityPlanner.Planner,
          as: "participant"
        )
      end

    assign(socket, form: to_form(form))
  end
end
