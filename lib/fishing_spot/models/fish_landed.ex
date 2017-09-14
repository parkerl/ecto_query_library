defmodule FishingSpot.FishLanded do
  alias FishingSpot.{Fisherman, FishSpecies, FlyType, Location}
  use Ecto.Schema
  import Ecto.Changeset

  schema "fish_landed" do
    timestamps()
    field :date_and_time,    :naive_datetime
    field :weight,           :decimal
    field :length,           :decimal

    belongs_to :fisherman,        Fisherman
    belongs_to :location,      Location
    belongs_to :fly_type,      FlyType
    belongs_to :fish_species,  FishSpecies
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(date_and_time, fisherman_id, location_id, fish_species))
  end
end
