defmodule FishingSpot.Repo.Migrations.AddFlyTypesTable do
  use Ecto.Migration

  def change do
    create table(:fly_types) do
      add :name,    :string

      timestamps
    end
  end
end
