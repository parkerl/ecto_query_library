defmodule FishingSpot.Fisherman do
  alias FishingSpot.FishermanTrip

  use Ecto.Model

  schema "fishermen" do
    timestamps
    field :name
    field :date_of_birth, Ecto.Date

    has_many :fishermen_trips, FishermanTrip
    has_many :trips, through: [:fishermen_trips, :trip]
    has_many :fish_landed, FishLanded
  end
end
