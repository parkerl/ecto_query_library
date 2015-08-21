defmodule FishingSpot.PersonTrip do
  alias FishingSpot.Person
  alias FishingSpot.Trip

  use Ecto.Model

  schema "people_trips" do
    timestamps
    belongs_to :person, Person
    belongs_to :trip,   Trip
  end
end
