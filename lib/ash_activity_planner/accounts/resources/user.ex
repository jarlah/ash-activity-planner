defmodule AshActivityPlanner.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication, AshAdmin.Resource]

  admin do
    actor? true
  end

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  authentication do
    api AshActivityPlanner.Accounts

    strategies do
      password :password do
        identity_field :email
      end
    end

    tokens do
      enabled? true
      token_resource AshActivityPlanner.Accounts.Token

      signing_secret AshActivityPlanner.Accounts.Secrets
    end
  end

  postgres do
    table "users"
    repo AshActivityPlanner.Repo
  end

  identities do
    identity :unique_email, [:email]
  end

  # If using policies, add the folowing bypass:
  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end
end
