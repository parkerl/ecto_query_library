defmodule FishingSpot.Location do
  use Ecto.Model

  schema "locations" do
    timestamps
    field :name
    field :altitude,  :integer
    field :lat,       :decimal
    field :long,      :decimal

    belongs_to :location_type, LocationType
  end
end
