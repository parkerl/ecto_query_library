defmodule FishingSpot.FishSpecies do
  use Ecto.Model

  schema "fish_species" do
    timestamps
    field :name
  end
end
