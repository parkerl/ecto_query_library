defmodule FishingSpot.Repo.Migrations.CustomPrimaryKey do
  use Ecto.Migration

  def change do
    create table(:tests, primary_key: false) do
      add :bigid, :bigint, primary_key: true

      timestamps
    end
  end
end
