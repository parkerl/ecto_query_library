defmodule FishingSpot.Repo.Migrations.AddLocationsTable do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name,             :string
      add :altitude,         :integer
      add :lat,              :decimal
      add :long,             :decimal
      add :location_type_id, references(:location_types)

      timestamps()
    end
  end
end
