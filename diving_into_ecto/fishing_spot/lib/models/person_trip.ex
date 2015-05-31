defmodule FishingSpots.PersonTrip do
  use Ecto.Model

  schema "people_trips" do
    has_one :person, Person
    has_one :trip,   Trip
  end
end
