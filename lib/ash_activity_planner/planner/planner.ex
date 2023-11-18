defmodule AshActivityPlanner.Planner do
  use Ash.Api

  resources do
    resource AshActivityPlanner.Planner.ActivityGroup
    resource AshActivityPlanner.Planner.Activity
    resource AshActivityPlanner.Planner.ActivityParticipant
    resource AshActivityPlanner.Planner.Participant
  end
end
