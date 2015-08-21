defmodule FishingSpot.Queries do
  alias FishingSpot.Repo
  alias FishingSpot.Location
  alias FishingSpot.LocationTrip
  alias FishingSpot.LocationType
  alias FishingSpot.Person
  alias FishingSpot.PersonTrip
  alias FishingSpot.FishLanded
  alias FishingSpot.FishSpecies
  alias FishingSpot.FlyType
  alias FishingSpot.Trip

  import Ecto.Query

  def biggest_fish do
    Repo.all(from p in FishLanded, select: max(p.length))
  end

  def biggest_fish_per_person do
    Repo.all(from f in FishLanded,
    join: p in assoc(f, :person),
    group_by: p.name,
    select: [max(f.length), p.name])
  end

  def biggest_fish_catcher do
    Repo.all(from f in FishLanded,
    left_join: f2 in FishLanded, on: (f.length < f2.length and f.id != f2.id ),
    join: p in assoc(f, :person),
    where: is_nil(f2.id),
    select: [f.length, p.name] )
  end

  def biggest_fish_per_person_per_trip do
    Repo.all(from f in FishLanded,
    join: p in assoc(f, :person),
    join: t in assoc(p, :trips),
    group_by: [p.name, t.start_date],
    select: [max(f.length), p.name, t.start_date])
  end
end
