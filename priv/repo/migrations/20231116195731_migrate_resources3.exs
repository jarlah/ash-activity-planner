defmodule AshActivityPlanner.Repo.Migrations.MigrateResources3 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:participants, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
      add :email, :text
      add :name, :text
      add :phone, :text
      add :description, :text
    end

    create table(:activity_participants, primary_key: false) do
      add :participant_id,
          references(:participants,
            column: :id,
            name: "activity_participants_participant_id_fkey",
            type: :uuid,
            prefix: "public"
          ),
          primary_key: true,
          null: false

      add :activity_id,
          references(:activities,
            column: :id,
            name: "activity_participants_activity_id_fkey",
            type: :uuid,
            prefix: "public"
          ),
          primary_key: true,
          null: false
    end
  end

  def down do
    drop constraint(:activity_participants, "activity_participants_participant_id_fkey")

    drop constraint(:activity_participants, "activity_participants_activity_id_fkey")

    drop table(:activity_participants)

    drop table(:participants)
  end
end
