defmodule AshActivityPlanner.Planner do
  use Ash.Api

  resources do
    registry AshActivityPlanner.Planner.Registry
  end
end
