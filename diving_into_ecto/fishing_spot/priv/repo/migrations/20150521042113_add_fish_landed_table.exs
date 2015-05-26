defmodule FishingSpot.Repo.Migrations.AddFishLandedTable do
  use Ecto.Migration

  def change do
    create table(:fish_landed) do
      add :date_and_time,    :datetime
      add :weight,           :decimal
      add :length,           :decimal
      references(:people)
      references(:locations)
      references(:fly_types)

      timestamps
    end
  end
end
