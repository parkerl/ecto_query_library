defmodule FishingSpot.LocationType do
  use Ecto.Model

  schema "location_types" do
    timestamps
    field :name
  end
end
