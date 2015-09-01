defmodule FishingSpot.Queries do
  alias FishingSpot.Repo
  alias FishingSpot.FishLanded

  import Ecto.Query

  def biggest_fish do
    Repo.all(from fish in FishLanded, select: max(fish.length))
  end

  def biggest_fish_per_fisherman do
    Repo.all(from f in FishLanded,
    join: p in assoc(f, :fisherman),
    group_by: p.name,
    select: [max(f.length), p.name])
  end

  def biggest_fish_catcher do
    Repo.all(from f in FishLanded,
    left_join: f2 in FishLanded, on: (f.length < f2.length and f.id != f2.id ),
    join: p in assoc(f, :fisherman),
    where: is_nil(f2.id),
    select: [f.length, p.name] )
  end

  def biggest_fish_catcher_in_clause do
    Repo.all(from f in FishLanded,
    join: p in assoc(f, :fisherman),
    where: fragment("? IN (SELECT MAX(fish.length) FROM fish_landed fish)", f.length),
    select: [f.length, p.name] )
  end

  def biggest_fish_per_fisherman_per_trip do
    Repo.all(from f in FishLanded,
    join: p in assoc(f, :fisherman),
    join: t in assoc(p, :trips),
    group_by: [p.name, t.start_date],
    select: [max(f.length), p.name, t.start_date])
  end

  def in_fish do
    Repo.all(from f in FishLanded,
             where: not(f.id in(^[1])),
             limit: 1
             )
  end
end
