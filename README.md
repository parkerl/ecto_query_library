This is basically the TL;DR for my Diving into Ecto series. I always hate having to skim a long blog post looking for a quick answer, and I know you do too. With that in mind I'm going to make this post a list of common and not so common queries you can do with Ecto. I will keep it up-to-date as I discover more interesting queries and ways of using Ecto. 

The repo with this post reproduced in the README can be found at [https://github.com/parkerl/ecto_query_library](https://github.com/parkerl/ecto_query_library). The queries below can be found in a usable form in `lib/queries.exs`. If you find something incorrect please open a pull request. I would like to make this a community resource rather than my personal toolbox. 

For the full story behind this project and the queries start here [Diving into Ecto: Part 1](http://www.glydergun.com/diving-into-ecto/).

# Simple Queries with Different Select Styles
_Demonstrates how the various select styles change the return structure._

```elixir

# Default: The entire model comes back as a list of structs.
Repo.all(
  from fisherman in Fisherman
)

06:11:18.292 [debug] SELECT f0."id", f0."inserted_at", f0."updated_at", f0."name", f0."date_of_birth" FROM "fishermen" AS f0 [] OK query=0.5ms
[%FishingSpot.Fisherman{meta: #Ecto.Schema.Metadata<:loaded>,
  date_of_birth: #Ecto.Date<1970-01-02>,
  fish_landed: #Ecto.Association.NotLoaded<association :fish_landed is not loaded>,
  fishermen_trips: #Ecto.Association.NotLoaded<association :fishermen_trips is not loaded>,
  id: 1, inserted_at: #Ecto.DateTime<2015-09-29T12:05:05Z>, name: "Mark",
  trips: #Ecto.Association.NotLoaded<association :trips is not loaded>,
  updated_at: #Ecto.DateTime<2015-09-29T12:05:05Z>},

# The same as above. The entire model comes back as a list of structs.
Repo.all(
  from fisherman in Fisherman,
  select: fisherman
)

06:11:18.292 [debug] SELECT f0."id", f0."inserted_at", f0."updated_at", f0."name", f0."date_of_birth" FROM "fishermen" AS f0 [] OK query=0.5ms
[%FishingSpot.Fisherman{meta: #Ecto.Schema.Metadata<:loaded>,
  date_of_birth: #Ecto.Date<1970-01-02>,
  fish_landed: #Ecto.Association.NotLoaded<association :fish_landed is not loaded>,
  fishermen_trips: #Ecto.Association.NotLoaded<association :fishermen_trips is not loaded>,
  id: 1, inserted_at: #Ecto.DateTime<2015-09-29T12:05:05Z>, name: "Mark",
  trips: #Ecto.Association.NotLoaded<association :trips is not loaded>,
  updated_at: #Ecto.DateTime<2015-09-29T12:05:05Z>},

# Selects only the given fields. Returns a list of lists. 
Repo.all(
  from fisherman in Fisherman,
  select: [fisherman.name, fisherman.date_of_birth]
)

06:11:18.305 [debug] SELECT f0."name", f0."date_of_birth" FROM "fishermen" AS f0 [] OK query=0.4ms
[["Mark", #Ecto.Date<1970-01-02>], ["Kirk", #Ecto.Date<1978-03-05>],
 ["Joe", #Ecto.Date<1973-10-15>], ["Lew", #Ecto.Date<1976-01-05>]]

# Selects only the given fields. Returns a list of tuples. 
Repo.all(
  from fisherman in Fisherman,
  select: { fisherman.name, fisherman.date_of_birth }
)

06:11:18.306 [debug] SELECT f0."name", f0."date_of_birth" FROM "fishermen" AS f0 [] OK query=0.4ms
[{"Mark", #Ecto.Date<1970-01-02>}, {"Kirk", #Ecto.Date<1978-03-05>},
 {"Joe", #Ecto.Date<1973-10-15>}, {"Lew", #Ecto.Date<1976-01-05>}]

# Selects only the given fields. Returns a list of maps with data in the given keys. 
Repo.all(
  from fisherman in Fisherman,
  select: %{ fisherman_name: fisherman.name, fisherman_dob: fisherman.date_of_birth }
)

06:11:18.307 [debug] SELECT f0."name", f0."date_of_birth" FROM "fishermen" AS f0 [] OK query=0.3ms
[%{fisherman_dob: #Ecto.Date<1970-01-02>, fisherman_name: "Mark"},
 %{fisherman_dob: #Ecto.Date<1978-03-05>, fisherman_name: "Kirk"},
 %{fisherman_dob: #Ecto.Date<1973-10-15>, fisherman_name: "Joe"},
 %{fisherman_dob: #Ecto.Date<1976-01-05>, fisherman_name: "Lew"}]
```

# Max

```elixir
from fish in FishLanded,
select: max(fish.length)
```

# Simple Where

```elixir
from fish in FishLanded,
where: fish.length > 24
```

# Count

```elixir
from fish in FishLanded,
select: count(fish.id),
where: fish.length > 24
```

# Group By with Max

```elixir
from fish in FishLanded,
join: fisherman in assoc(fish, :fisherman),
group_by: fisherman.name,
select: [max(fish.length), fisherman.name]
```

# Order By
_Demonstrates ordering ascending and descending._

```elixir
from fisherman in Fisherman,
order_by: fisherman.name,
select: fisherman.name

21:50:02.022 [debug] SELECT f0."name" FROM "fishermen" AS f0 ORDER BY f0."name" [] OK query=4.0ms
["Joe", "Kirk", "Lew", "Mark"]

from fisherman in Fisherman,
order_by: [desc: fisherman.name],
select: fisherman.name

21:50:02.025 [debug] SELECT f0."name" FROM "fishermen" AS f0 ORDER BY f0."name" DESC [] OK query=0.5ms
["Mark", "Lew", "Kirk", "Joe"]
```

# Record with Max Value in Two Steps
_Demonstrates interpolating the result of one query into another._

```elixir

biggest_fish = from fish in FishLanded,
               select: max(fish.length)

Repo.all(
  from fish in FishLanded,
  join: fisherman in assoc(fish, :fisherman),
  where: fish.length == ^biggest_fish, 
  select: [fish.length, fisherman.name]
)
```

# Record with Max Value via Self Join
_Demonstrates left joins, self joins, and conditions in joins. Calculates the
record with a maximum value by "folding" onto the same table._

```elixir
from fish in FishLanded,
left_join: bigger_fish in FishLanded, on: fish.length < bigger_fish.length,
join: fisherman in assoc(fish, :fisherman),
where: is_nil(bigger_fish.id),
select: [fish.length, fisherman.name]
```

# Record with Max Value via Subquery
_Demonstrates subqueries in where clauses._

```elixir
from fish in FishLanded,
join: fisherman in assoc(fish, :fisherman),
where: fragment(
    "? IN (SELECT MAX(biggest_fish.length) FROM fish_landed biggest_fish)", fish.length
  ),
select: [fish.length, fisherman.name]
```

# Where with In Clause

```elixir
from fish in FishLanded,
join: fisherman in assoc(fish, :fisherman),
where: fisherman.name in ["Mark", "Kirk"],
group_by: fisherman.name,
order_by: fisherman.name,
select: %{biggest_fish: max(fish.length), fisherman: fisherman.name}
```

# Where with Not In Clause
_Demonstrates the use of `not` to negate an in clause._

```elixir
from fish in FishLanded,
join: fisherman in assoc(fish, :fisherman),
where: not fisherman.name in ["Mark", "Kirk"],
group_by: fisherman.name,
order_by: fisherman.name,
select: %{biggest_fish: max(fish.length), fisherman: fisherman.name}
```

# Complex Muti-join Multi-where

_Demonstrates joins, sub-querying and using map syntax in the select. 
Uses the `date_add/3` function. Demonstrates how to accomplish a "between" where clause._

```elixir
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
```

# Using a Select Fragment
## with Named Grouping and Positional Ordering

_Demonstrates how to use a named column from a fragment or a positional
column from an aggregate function in grouping or ordering._

```elixir
from fish in FishLanded,
group_by: fragment("date"),
order_by: fragment("2"),
select: %{
  date: fragment("date_trunc('day', ?) AS date", field(fish, :date_and_time)),
  fish_count: count(fish.id)
}
```

# Complex Select Logic Using a Fragment

_Demonstrates how to use multiple columns to calculate a value.
Also orders descending using positional column selection._

```elixir
from fish in FishLanded,
join: fisherman in assoc(fish, :fisherman),
order_by: [desc: fragment("1")],
select: %{
  bool: fragment(
    "((? = 'Kirk' OR ? = 'Mark') AND NOT ? < 10) AS crazy_select",
    field(fisherman, :name),
    field(fisherman, :name),
    field(fish, :length)),
  fisherman: fisherman.name
}
```


# Partial-preloading

_Demonstrates how to select only parts of a join model in a preload. 
Uses both map and list select syntax._

```elixir
    query = Fisherman
        |> join(:inner, [fisherman], fish in assoc(fisherman, :fish_landed))
        |> where([fisherman], fisherman.id == 1)
        |> select([fisherman, fish], %{fisherman: fisherman, length: fish.length})
        |> preload([fisherman, fish], [fish_landed: fish])

    Repo.one(query).fisherman.fish_landed |> IO.inspect

    query = Fisherman
        |> join(:inner, [fisherman], fish in assoc(fisherman, :fish_landed))
        |> where([fisherman], fisherman.id == 1)
        |> select([fisherman, fish], %{fisherman: fisherman, length: fish.length})
        |> preload([fisherman, fish], [fish_landed: fish])

    fisherman = Repo.one(query) |> List.first
    fisherman.fish_landed |> IO.inspect
```

# Binding Fun

_Demonstrates that bindings are order and not name dependent. See [http://www.glydergun.com/a-bit-about-bindings/](http://www.glydergun.com/a-bit-about-bindings/)._

```elixir
FishLanded
      |> join(:inner, [fish], fly_type in assoc(fish, :fly_type))
      |> join(:inner, [fish, fly_type], fish_species in assoc(fish, :fish_species))
      |> join(:inner, [fish, fly_type, fish_type], fisherman in assoc(fish, :fisherman))
      |> join(:inner, [fish, fly_type, fish_type, fisherman], trip in assoc(fisherman, :trips))
      |> join(:inner, [fish, fly_type, fish_type, fisherman, trip],
              locations in assoc(trip, :locations))
      |> join(:inner, [fish, fly_type, fish_type, fisherman, trip, location],
              location_types in assoc(location, :location_type))
      |> select([fish], count(fish.id))

FishLanded
      |> join(:inner, [fish], fly_type in assoc(fish, :fly_type))
      |> join(:inner, [fish], fish_species in assoc(fish, :fish_species))
      |> join(:inner, [fish], fisherman in assoc(fish, :fisherman))
      |> join(:inner, [fish, fly_type, fish_type, fisherman],
              trip in assoc(fisherman, :trips))
      |> join(:inner, [fish, fly_type, fish_type, fisherman, trip],
              locations in assoc(trip, :locations))
      |> join(:inner, [fish, fly_type, fish_type, fisherman, trip, location],
              location_types in assoc(location, :location_type))
      |> select([fish], count(fish.id))

FishLanded
      |> join(:inner, [fish], fly_type in assoc(fish, :fly_type))
      |> join(:inner, [nemo], fish_species in assoc(nemo, :fish_species))
      |> join(:inner, [bait], fisherman in assoc(bait, :fisherman))
      |> join(:inner, [foo, bar, baz, ahab], trip in assoc(ahab, :trips))
      |> join(:inner, [foo, bar, baz, ahab, set_sail], locations in assoc(set_sail, :locations))
      |> join(:inner, [x, y, z, a, b, c], location_types in assoc(c, :location_type))
      |> select([whatever], count(whatever.id))
```

# Working With Prefixes
_Demostrates how to work with schemas other than "public" in Postgres._

```elixir
# The migration
  def change do
    execute "CREATE SCHEMA users"

    create table(:accounts, prefix: :users) do
      add :identifier, :string
      add :name,       :string

      timestamps
    end
  end
  
# Inserting data
    Repo.insert Ecto.Model.put_meta( %Account{ identifier: "lew@example.com",  name: "Lew"  }, prefix: "users" )
    Repo.insert Ecto.Model.put_meta( %Account{ identifier: "mark@example.com", name: "Mark" }, prefix: "users" )
    Repo.insert Ecto.Model.put_meta( %Account{ identifier: "john@example.com", name: "John" }, prefix: "users" )

#Querying
    query = from accounts in Account
    Repo.all(%{query | prefix: "users"})
```
