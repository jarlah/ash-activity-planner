defmodule AshActivityPlanner.Planner.ActivityParticipant do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "activity_participants"
    repo AshActivityPlanner.Repo
  end

  actions do
    defaults [:create, :read, :destroy]
  end

  relationships do
    belongs_to :participant, AshActivityPlanner.Planner.Participant do
      primary_key? true
      allow_nil? false
    end

    belongs_to :activity, AshActivityPlanner.Planner.Activity do
      primary_key? true
      allow_nil? false
    end
  end
end
