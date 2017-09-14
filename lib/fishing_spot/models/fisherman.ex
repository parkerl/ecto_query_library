defmodule FishingSpot.Fisherman do
  alias FishingSpot.FishermanTrip
  alias FishingSpot.FishLanded

  use Ecto.Schema

  schema "fishermen" do
    timestamps
    field :name
    field :date_of_birth, Ecto.Date

    has_many :fishermen_trips, FishermanTrip
    has_many :trips, through: [:fishermen_trips, :trip]
    has_many :trip_locations, through: [:trips, :locations]
    has_many :fish_landed, FishLanded
  end
end
