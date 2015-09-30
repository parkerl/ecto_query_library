defmodule FishingSpot.Location do
  use Ecto.Model
  alias FishingSpot.LocationType

  schema "locations" do
    timestamps
    field :name
    field :altitude,  :integer
    field :lat,       :decimal
    field :long,      :decimal

    belongs_to :location_type, LocationType
  end
end
