defmodule DivingIntoEcto.Repo.Migrations.AddPeopleTable do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :name,          :string
      add :date_of_birth, :date

      timestamps
    end
  end
end
