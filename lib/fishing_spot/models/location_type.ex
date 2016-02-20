defmodule FishingSpot.LocationType do
  use Ecto.Schema

  schema "location_types" do
    timestamps
    field :name
  end
end
