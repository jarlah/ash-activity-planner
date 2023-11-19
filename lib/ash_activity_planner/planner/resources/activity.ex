defmodule AshActivityPlanner.Planner.Activity do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "activities"
    repo AshActivityPlanner.Repo
  end

  relationships do
    belongs_to :activity_group, AshActivityPlanner.Planner.ActivityGroup do
      primary_key? true
    end

    many_to_many :participants, AshActivityPlanner.Planner.Participant do
      through AshActivityPlanner.Planner.ActivityParticipant
      source_attribute_on_join_resource :activity_id
      destination_attribute_on_join_resource :participant_id
    end
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      argument :participants, {:array, :map}

      change manage_relationship(:participants,
               type: :append_and_remove,
               on_no_match: :create
             )
    end

    read :next_two_days do
      now = Timex.now()
      start_time = now
      end_time = Timex.shift(now, days: +2)
      filter expr(start_time >= ^start_time and end_time <= ^end_time)
    end

    read :last_two_days do
      now = Timex.now()
      start_time = Timex.shift(now, days: -2)
      end_time = now
      filter expr(start_time >= ^start_time and end_time <= ^end_time)
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :title, :string
    attribute :description, :string
    attribute :start_time, :utc_datetime
    attribute :end_time, :utc_datetime
    attribute :activity_group_id, :uuid
  end

  code_interface do
    define_for AshActivityPlanner.Planner
    define :create
    define :read
    define :by_id, get_by: [:id], action: :read
    define :update
    define :destroy
    define :last_two_days
    define :next_two_days
  end
end
