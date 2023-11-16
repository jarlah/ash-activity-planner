defmodule AshActivityPlanner.Planner.ActivityGroup do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "activity_groups"
    repo AshActivityPlanner.Repo
  end

  relationships do
    has_many :activities, AshActivityPlanner.Planner.Activity do
      destination_attribute :activity_group_id
    end
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  attributes do
    uuid_primary_key :id
    attribute :title, :string
    attribute :description, :string
  end
end
