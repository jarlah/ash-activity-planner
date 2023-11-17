defmodule AshActivityPlannerWeb.ActivityLive.FormComponent do
  use AshActivityPlannerWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage activity records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="activity-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <%= if @form.source.type == :create do %>
          <.input
            field={@form[:participants]}
            type="select"
            multiple
            label="Participants"
            options={[]}
          />
          <.input field={@form[:id]} type="text" label="Id" /><.input
            field={@form[:title]}
            type="text"
            label="Title"
          /><.input field={@form[:description]} type="text" label="Description" /><.input
            field={@form[:start_time]}
            type="datetime-local"
            label="Start time"
          /><.input field={@form[:end_time]} type="datetime-local" label="End time" /><.input
            field={@form[:activity_group_id]}
            type="text"
            label="Activity group"
          />
        <% end %>
        <%= if @form.source.type == :update do %>
          <.input field={@form[:id]} type="text" label="Id" /><.input
            field={@form[:title]}
            type="text"
            label="Title"
          /><.input field={@form[:description]} type="text" label="Description" /><.input
            field={@form[:start_time]}
            type="datetime-local"
            label="Start time"
          /><.input field={@form[:end_time]} type="datetime-local" label="End time" /><.input
            field={@form[:activity_group_id]}
            type="text"
            label="Activity group"
          />
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving...">Save Activity</.button>
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
  def handle_event("validate", %{"activity" => activity_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, activity_params))}
  end

  def handle_event("save", %{"activity" => activity_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: activity_params) do
      {:ok, activity} ->
        notify_parent({:saved, activity})

        socket =
          socket
          |> put_flash(:info, "Activity #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{activity: activity}} = socket) do
    form =
      if activity do
        AshPhoenix.Form.for_update(activity, :update,
          api: AshActivityPlanner.Planner,
          as: "activity"
        )
      else
        AshPhoenix.Form.for_create(AshActivityPlanner.Planner.Activity, :create,
          api: AshActivityPlanner.Planner,
          as: "activity"
        )
      end

    assign(socket, form: to_form(form))
  end
end
