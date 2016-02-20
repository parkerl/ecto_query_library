defmodule FishingSpot.FishSpecies do
  use Ecto.Schema

  schema "fish_species" do
    timestamps
    field :name
  end
end
