This is bascially the TL;DR for my Diving into Ecto series. I always hate having to skim a long blog post looking for a quick answer, and I know you do too. With that in mind I'm going to make this post a list of common and not so common queries you can do with Ecto. 

__Simple Queries with Different Select Styles__

```elixir

# Default: The entire model comes back as a list of structs.
Repo.all(
  from fisherman in Fisherman
)

06:11:18.292 [debug] SELECT f0."id", f0."inserted_at", f0."updated_at", f0."name", f0."date_of_birth" FROM "fishermen" AS f0 [] OK query=0.5ms
[%FishingSpot.Fisherman{__meta__: #Ecto.Schema.Metadata<:loaded>,
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
[%FishingSpot.Fisherman{__meta__: #Ecto.Schema.Metadata<:loaded>,
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

__Max__

```elixir
from fish in FishLanded,
select: max(fish.length)
```

__Simple Where__

```elixir
from fish in FishLanded,
where: fish.length > 24
```

__Count__

```elixir
from fish in FishLanded,
select: count(fish.id),
where: fish.length > 24
```

__Group By with Max__

```elixir
from fish in FishLanded,
join: fisherman in assoc(fish, :fisherman),
group_by: fisherman.name,
select: [max(fish.length), fisherman.name]
```

__Record with Max Value in Two Steps__

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

__Record with Max Value via Self Join__

```elixir
from fish in FishLanded,
left_join: bigger_fish in FishLanded, on: fish.length < bigger_fish.length,
join: fisherman in assoc(fish, :fisherman),
where: is_nil(bigger_fish.id),
select: [fish.length, fisherman.name]
```

__Record with Max Value via Subquery__

```elixir
from fish in FishLanded,
join: fisherman in assoc(fish, :fisherman),
where: fragment(
    "? IN (SELECT MAX(biggest_fish.length) FROM fish_landed biggest_fish)", fish.length
  ),
select: [fish.length, fisherman.name]
```

__Complex Muti-join Multi-where Query__

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
