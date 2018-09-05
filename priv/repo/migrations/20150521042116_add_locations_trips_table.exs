defmodule FishingSpot.Repo.Migrations.AddLocationsTripsTable do
  use Ecto.Migration

  def change do
    create table(:locations_trips) do
      add :location_id, references(:locations)
      add :trip_id,     references(:trips)

      timestamps()
    end
  end
end
