defmodule FishingSpot.Repo.Migrations.AddAccountsTable do
  use Ecto.Migration

  def change do
    execute "CREATE SCHEMA users"

    create table(:accounts, prefix: :users) do
      add :identifier, :string
      add :name,       :string

      timestamps()
    end
  end
end
