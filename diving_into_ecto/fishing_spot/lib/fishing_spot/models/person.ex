defmodule FishingSpot.Person do
  alias FishingSpot.PersonTrip

  use Ecto.Model

  schema "people" do
    timestamps
    field :name
    field :date_of_birth, Ecto.Date

    has_many :people_trips, PersonTrip
    has_many :trips, through: [:people_trips, :trip]
    has_many :fish_landed, FishLanded
  end
end
