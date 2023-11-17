defmodule AshActivityPlanner.Accounts do
  use Ash.Api

  resources do
    resource AshActivityPlanner.Accounts.User
    resource AshActivityPlanner.Accounts.Token
  end
end
