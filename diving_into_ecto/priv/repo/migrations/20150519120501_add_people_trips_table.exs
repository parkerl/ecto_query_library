defmodule DivingIntoEcto.Repo.Migrations.AddPeopleTripsTable do
  use Ecto.Migration

  def change do
    create table(:people_trips) do
      add :person_id,  references(:people)
      add :trip_id,    references(:trips)

      timestamps
    end
  end
end
