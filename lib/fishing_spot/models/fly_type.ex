defmodule FishingSpot.FlyType do
  use Ecto.Schema

  schema "fly_types" do
    timestamps()
    field :name
  end
end
