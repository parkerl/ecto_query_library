defmodule FishingSpot.Repo.Migrations.AddFishSpeciesTable do
  use Ecto.Migration

  def change do
    create table(:fish_species) do
      add :name,    :string

      timestamps
    end
  end
end
