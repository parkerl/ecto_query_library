defmodule FishingSpots.Person do
  use Ecto.Model

  schema "people" do
    field :name
    field :date_of_birth, :date
  end
end
