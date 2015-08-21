defmodule FishingSpot.FishLanded do
  alias FishingSpot.Person
  alias FishingSpot.FishLanded
  alias FishingSpot.FishSpecies
  alias FishingSpot.FlyType
  use Ecto.Model

  schema "fish_landed" do
    timestamps
    field :date_and_time,    :datetime
    field :weight,           :decimal
    field :length,           :decimal

    belongs_to :person,        Person
    belongs_to :location,      Location
    belongs_to :fly_type,      FlyType
    belongs_to :fish_species,  FishSpecies
  end
end
