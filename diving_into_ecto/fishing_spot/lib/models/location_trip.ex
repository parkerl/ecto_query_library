defmodule FishingSpots.LocationTrip do
  use Ecto.Model

  schema "locations_trips" do
    has_one :location, Location
    has_one :trip,     Trip
  end
end
