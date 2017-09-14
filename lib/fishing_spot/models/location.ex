defmodule FishingSpot.Location do
  use Ecto.Schema
  import Ecto.Changeset
  alias FishingSpot.LocationType

  schema "locations" do
    timestamps()
    field :name
    field :altitude,  :integer
    field :lat,       :decimal
    field :long,      :decimal

    belongs_to :location_type, LocationType
  end

   def changeset(model, params \\ :empty) do
     model
       |> cast(params, ~w(name))
   end
end
