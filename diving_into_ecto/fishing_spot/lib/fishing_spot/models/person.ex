defmodule FishingSpot.Person do
  use Ecto.Model

  schema "people" do
    timestamps
    field :name
    field :date_of_birth, :date

    has_many :people_trips, PersonTrip
    has_many :trips, through: [:people_trips, :person]
  end
end
