defmodule FishingSpot.Repo.Migrations.AddLocationsTripsTable do
  use Ecto.Migration

  def change do
    references(:locations)
    references(:trips)
  end
end
