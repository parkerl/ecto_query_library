defmodule FishingSpot.Repo.Migrations.AddPeopleTripsTable do
  use Ecto.Migration

  def change do
    create table(:fishermen_trips) do
      add :fisherman_id, references(:fishermen)
      add :trip_id, references(:trips)

      timestamps
    end
  end
end
