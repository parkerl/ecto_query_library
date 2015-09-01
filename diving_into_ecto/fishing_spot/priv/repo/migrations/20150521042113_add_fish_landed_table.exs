defmodule FishingSpot.Repo.Migrations.AddFishLandedTable do
  use Ecto.Migration

  def change do
    create table(:fish_landed) do
      add :date_and_time,    :datetime
      add :weight,           :decimal
      add :length,           :decimal

      add :fisherman_id, references(:fishermen)
      add :location_id, references(:locations)
      add :fly_type_id, references(:fly_types)
      add :fish_species_id, references(:fish_species)

      timestamps
    end
  end
end
