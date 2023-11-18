defmodule AshActivityPlanner.Accounts do
  use Ash.Api,
    extensions: [AshAdmin.Api]

  admin do
    show? true
  end

  resources do
    resource AshActivityPlanner.Accounts.User
    resource AshActivityPlanner.Accounts.Token
  end
end
