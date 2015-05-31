defmodule FishingSpots.FishLanded do
  use Ecto.Model

  schema "fish_landed" do
    field :date_and_time,    :datetime
    field :weight,           :decimal
    field :length,           :decimal
    has_one :person,         Person
    has_one :location,       Location
    has_one :fly_type,       FlyType
  end
end
