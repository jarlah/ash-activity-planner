defmodule AshActivityPlannerWeb.ActivityGroupLive.FormComponent do
  use AshActivityPlannerWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage activity_group records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="activity_group-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:id]} type="text" label="Id" /><.input
          field={@form[:title]}
          type="text"
          label="Title"
        /><.input field={@form[:description]} type="text" label="Description" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Activity group</.button>
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
  def handle_event("validate", %{"activity_group" => activity_group_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, activity_group_params))}
  end

  def handle_event("save", %{"activity_group" => activity_group_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: activity_group_params) do
      {:ok, activity_group} ->
        notify_parent({:saved, activity_group})

        socket =
          socket
          |> put_flash(:info, "Activity group #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{activity_group: activity_group}} = socket) do
    form =
      if activity_group do
        AshPhoenix.Form.for_update(activity_group, :update,
          api: AshActivityPlanner.Planner,
          as: "activity_group"
        )
      else
        AshPhoenix.Form.for_create(AshActivityPlanner.Planner.ActivityGroup, :create,
          api: AshActivityPlanner.Planner,
          as: "activity_group"
        )
      end

    assign(socket, form: to_form(form))
  end
end
