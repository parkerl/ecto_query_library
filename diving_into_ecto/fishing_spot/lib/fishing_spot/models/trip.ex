defmodule FishingSpot.Trip do
  use Ecto.Model

  schema "trips" do
    timestamps
    field :start_date,  Ecto.Date
    field :end_date,    Ecto.Date

    has_many :locations_trips, LocationTrip
    has_many :locations, through: [:locations_trips, :location]
  end
end
