defmodule FishingSpot.Repo.Migrations.AddTripsTable do
  use Ecto.Migration

  def change do
    create table(:trips) do
      add :start_date,  :date
      add :end_date,    :date

      timestamps
    end
  end
end
