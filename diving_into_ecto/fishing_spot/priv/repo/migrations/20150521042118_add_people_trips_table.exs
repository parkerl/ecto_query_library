defmodule FishingSpot.Repo.Migrations.AddPeopleTripsTable do
  use Ecto.Migration

  def change do
    references(:people)
    references(:trips)
  end
end
