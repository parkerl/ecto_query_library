defmodule FishingSpot.QueryExamples.Selects do
  alias FishingSpot.Repo
  alias FishingSpot.FishLanded
  alias FishingSpot.Fisherman
  alias FishingSpot.Account

  import Ecto.Query

  @moduledoc """
  These examples demonstrate the different styles of Ecto
  select clauses.
  """

  @doc """
  By default an `Ecto` query will return a `List` of structs. The
  struct will be the type of the schema given in the `from/2` clause
  ( `Ecto.Query.from/2`  ). In this case they will be
  `%FishingSpot.Fisherman{}` structs.

  $$query FishingSpot.QueryExamples.Selects.default_return

  """
  def default_return do
    from fisherman in Fisherman
  end

  @doc """

  $$query FishingSpot.QueryExamples.Selects.big_query

  """
  def big_query do
    from fish in FishLanded,
      join: fly_type in assoc(fish, :fly_type),
      join: fish_species in assoc(fish, :fish_species),
      join: fisherman in assoc(fish, :fisherman),
      join: trip in assoc(fisherman, :trips),
      join: locations in assoc(trip, :locations),
      join: location_types in assoc(locations, :location_type),
      where: fragment(
        "? IN (SELECT MAX(biggest_fish.length) FROM fish_landed biggest_fish)", fish.length
      ),
      where: fish.date_and_time >= trip.start_date,
      where: fish.date_and_time <= date_add(trip.end_date, 1, "day"),
      select: %{
        length: fish.length,
        date_caught: fish.date_and_time,
        fish_type: fish_species.name,
        fly: fly_type.name,
        fisherman: fisherman.name,
        trip_start: trip.start_date,
        trip_end: trip.end_date,
        location: locations.name,
        location_type: location_types.name
      }
  end
end
