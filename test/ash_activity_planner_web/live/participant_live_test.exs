defmodule AshActivityPlannerWeb.ParticipantLiveTest do
  use AshActivityPlannerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias AshActivityPlanner.Planner.Participant

  @create_attrs %{
    name: "some name",
    description: "some description",
    email: "some email",
    phone: "some phone"
  }
  @update_attrs %{
    name: "some updated name",
    description: "some updated description",
    email: "some updated email",
    phone: "some updated phone"
  }
  @invalid_attrs %{name: nil, description: nil, email: nil, phone: nil}

  defp create_participant(_) do
    participant = Participant.create!(%{name: "Test name"})
    %{participant: participant}
  end

  describe "Index" do
    setup [:create_participant]

    test "lists all participants", %{conn: conn, participant: participant} do
      {:ok, _index_live, html} = live(conn, ~p"/participants")

      assert html =~ "Listing Participants"
      assert html =~ participant.name
    end

    test "saves new participant", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/participants")

      assert index_live |> element("a", "New Participant") |> render_click() =~
               "New Participant"

      assert_patch(index_live, ~p"/participants/new")

      assert index_live
             |> form("#participant-form", participant: @invalid_attrs)
             |> render_change() =~ "is required"

      assert index_live
             |> form("#participant-form", participant: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/participants")

      html = render(index_live)
      assert html =~ "Participant created successfully"
      assert html =~ "some name"
    end

    test "updates participant in listing", %{conn: conn, participant: participant} do
      {:ok, index_live, _html} = live(conn, ~p"/participants")

      assert index_live |> element("#participants-#{participant.id} a", "Edit") |> render_click() =~
               "Edit Participant"

      assert_patch(index_live, ~p"/participants/#{participant}/edit")

      assert index_live
             |> form("#participant-form", participant: @invalid_attrs)
             |> render_change() =~ "is required"

      assert index_live
             |> form("#participant-form", participant: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/participants")

      html = render(index_live)
      assert html =~ "Participant updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes participant in listing", %{conn: conn, participant: participant} do
      {:ok, index_live, _html} = live(conn, ~p"/participants")

      assert index_live
             |> element("#participants-#{participant.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#participants-#{participant.id}")
    end
  end

  describe "Show" do
    setup [:create_participant]

    test "displays participant", %{conn: conn, participant: participant} do
      {:ok, _show_live, html} = live(conn, ~p"/participants/#{participant}")

      assert html =~ "Show Participant"
      assert html =~ participant.name
    end

    test "updates participant within modal", %{conn: conn, participant: participant} do
      {:ok, show_live, _html} = live(conn, ~p"/participants/#{participant}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Participant"

      assert_patch(show_live, ~p"/participants/#{participant}/show/edit")

      assert show_live
             |> form("#participant-form", participant: @invalid_attrs)
             |> render_change() =~ "is required"

      assert show_live
             |> form("#participant-form", participant: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/participants/#{participant}")

      html = render(show_live)
      assert html =~ "Participant updated successfully"
      assert html =~ "some updated name"
    end
  end
end
