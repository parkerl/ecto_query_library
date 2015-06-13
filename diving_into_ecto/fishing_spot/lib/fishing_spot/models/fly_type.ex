defmodule FishingSpot.FlyType do
  use Ecto.Model

  schema "fly_types" do
    timestamps
    field :name
  end
end
