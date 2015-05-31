defmodule FishingSpots.Location do
  use Ecto.Model

  schema "locations" do
    field :name
    field :altitude,  :integer
    field :lat,       :decimal
    field :long,      :decimal
  end
end
