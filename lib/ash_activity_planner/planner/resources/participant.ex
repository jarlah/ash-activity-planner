defmodule AshActivityPlanner.Planner.Participant do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "participants"
    repo AshActivityPlanner.Repo
  end

  relationships do
    many_to_many :activities, AshActivityPlanner.Planner.Activity do
      through AshActivityPlanner.Planner.ActivityParticipant
      source_attribute_on_join_resource :participant_id
      destination_attribute_on_join_resource :activity_id
    end
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      argument :activities, {:array, :map}

      change manage_relationship(:activities,
               type: :append_and_remove,
               on_no_match: :create
             )
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :email, :string
    attribute :name, :string
    attribute :phone, :string
    attribute :description, :string
  end

  code_interface do
    define_for AshActivityPlanner.Planner
    define :create
    define :read
    define :by_id, get_by: [:id], action: :read
    define :by_name, get_by: [:name], action: :read
    define :update
    define :destroy
  end
end
