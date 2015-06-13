defmodule FishingSpot.LocationTrip do
  use Ecto.Model

  schema "locations_trips" do
    timestamps
    belongs_to :location, Location
    belongs_to :trip,     Trip
  end
end
