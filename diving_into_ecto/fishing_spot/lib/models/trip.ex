defmodule FishingSpots.Trip do
  use Ecto.Model

  schema "trips" do
    field :start_date,  :date
    field :end_date,    :date
  end
end
