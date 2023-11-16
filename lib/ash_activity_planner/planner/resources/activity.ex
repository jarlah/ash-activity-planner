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
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  attributes do
    uuid_primary_key :id
    attribute :title, :string
    attribute :description, :string
    attribute :start_time, :utc_datetime
    attribute :end_time, :utc_datetime
    attribute :activity_group_id, :uuid
  end
end
