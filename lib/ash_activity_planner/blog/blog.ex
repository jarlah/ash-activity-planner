defmodule AshActivityPlanner.Blog do
  use Ash.Api

  resources do
    registry AshActivityPlanner.Blog.Registry
  end
end
