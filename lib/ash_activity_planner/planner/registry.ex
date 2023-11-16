defmodule AshActivityPlanner.Planner.Registry do
  use Ash.Registry,
    extensions: [
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry AshActivityPlanner.Planner.ActivityGroup
    entry AshActivityPlanner.Planner.Activity
  end
end
