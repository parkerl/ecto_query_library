defmodule FishingSpot.Data do
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

  def generate do
    Mix.Task.run "ecto.drop",     ["FishingSpot.Repo"]
    Mix.Task.run "ecto.create",   ["FishingSpot.Repo"]
    Mix.Task.run "ecto.migrate",  ["FishingSpot.Repo"]

    Repo.transaction(fn ->
      _generate
    end)
  end

  defp _generate do
    IO.puts "Generating data"

    rainbow_trout   = Repo.insert %FishSpecies{  name: "Rainbow Trout"   }
    brown_trout     = Repo.insert %FishSpecies{  name: "brown Trout"     }
    lake_trout      = Repo.insert %FishSpecies{  name: "lake Trout"      }
    brook_trout     = Repo.insert %FishSpecies{  name: "Brook Trout"     }
    cutthroat_trout = Repo.insert %FishSpecies{  name: "Cutthroat Trout" }

    fish = [rainbow_trout, brown_trout, lake_trout, brook_trout, cutthroat_trout]

    muddler      = Repo.insert %FlyType{  name: "Muddler Minnow" }
    hairs_ear    = Repo.insert %FlyType{  name: "Hairs Ear"      }
    copper_john  = Repo.insert %FlyType{  name: "Copper John"    }
    royal_wulff  = Repo.insert %FlyType{  name: "Royal Wulff"    }
    morning_dunn = Repo.insert %FlyType{  name: "Morning Dunn"   }

    flies = [muddler, hairs_ear, copper_john, royal_wulff, morning_dunn]

    lake         = Repo.insert %LocationType{  name: "Lake"         }
    pond         = Repo.insert %LocationType{  name: "Pond"         }
    spring_creek = Repo.insert %LocationType{  name: "Spring Creek" }
    stream       = Repo.insert %LocationType{  name: "Stream"       }
    river        = Repo.insert %LocationType{  name: "River"        }
    tail_water   = Repo.insert %LocationType{  name: "Tail Water"   }

    mark = Repo.insert %Person{ name: "Mark",  date_of_birth: { 1970,  1,    2 }}
    kirk = Repo.insert %Person{ name: "Kirk",  date_of_birth: { 1978,  3,    5 }}
    joe  = Repo.insert %Person{ name: "Joe",   date_of_birth: { 1973,  10,  15 }}
    lew  = Repo.insert %Person{ name: "Lew",   date_of_birth: { 1976,  1,    5 }}

    people = [mark, kirk, joe, lew]

    trip1  = Repo.insert %Trip{ start_date: { 2012,   6,   5 }, end_date: { 2012,   6,  12 }}
    trip2  = Repo.insert %Trip{ start_date: { 2012,  10,  15 }, end_date: { 2012,  10,  20 }}
    trip3  = Repo.insert %Trip{ start_date: { 2013,   9,   1 }, end_date: { 2013,   9,   2 }}
    trip4  = Repo.insert %Trip{ start_date: { 2014,   7,  15 }, end_date: { 2014,   7,  20 }}
    trip5  = Repo.insert %Trip{ start_date: { 2014,   8,   8 }, end_date: { 2014,   8,  18 }}

    trips = [trip1, trip2, trip3, trip4, trip5]

    lake_fork   = Repo.insert %Location{name: "Lake Fork",               altitude: 8000,  lat: Decimal.new(38.090942),  long: Decimal.new(-107.292869),  location_type_id: river.id        }
    blue_mesa   = Repo.insert %Location{name: "Blue Mesa",               altitude: 7000,  lat: Decimal.new(38.472406),  long: Decimal.new(-107.210268),  location_type_id: lake.id         }
    main_elk    = Repo.insert %Location{name: "Main Elk Creek",          altitude: 7000,  lat: Decimal.new(39.729579),  long: Decimal.new(-107.545462),  location_type_id: spring_creek.id }
    frying_pan  = Repo.insert %Location{name: "Frying Pan Tailwater",    altitude: 6000,  lat: Decimal.new(39.363448),  long: Decimal.new(-106.823121),  location_type_id: tail_water.id   }
    unamed_pond = Repo.insert %Location{name: "Unamed Pond",             altitude: 5000,  lat: Decimal.new(39.887929),  long: Decimal.new(-107.354998),  location_type_id: pond.id         }
    white_river = Repo.insert %Location{name: "North Fork White River",  altitude: 5000,  lat: Decimal.new(40.051879),  long: Decimal.new(-107.458016),  location_type_id: pond.id         }

    locations = [lake_fork, blue_mesa, main_elk, frying_pan, unamed_pond, white_river]

    Repo.insert %LocationTrip{location_id: lake_fork.id,    trip_id: trip1.id}
    Repo.insert %LocationTrip{location_id: blue_mesa.id,    trip_id: trip1.id}
    Repo.insert %LocationTrip{location_id: main_elk.id,     trip_id: trip2.id}
    Repo.insert %LocationTrip{location_id: frying_pan.id,   trip_id: trip2.id}
    Repo.insert %LocationTrip{location_id: lake_fork.id,    trip_id: trip3.id}
    Repo.insert %LocationTrip{location_id: blue_mesa.id,    trip_id: trip3.id}
    Repo.insert %LocationTrip{location_id: main_elk.id,     trip_id: trip4.id}
    Repo.insert %LocationTrip{location_id: frying_pan.id,   trip_id: trip4.id}
    Repo.insert %LocationTrip{location_id: unamed_pond.id,  trip_id: trip4.id}
    Repo.insert %LocationTrip{location_id: white_river.id,  trip_id: trip4.id}
    Repo.insert %LocationTrip{location_id: lake_fork.id,    trip_id: trip5.id}

    Enum.each(1..1000, fn(_) ->
      :random.seed(:erlang.now)

      [person  |_]              = Enum.shuffle(people)
      [location|_]              = Enum.shuffle(locations)
      [fly     |_]              = Enum.shuffle(flies)
      [trip    |_]              = Enum.shuffle(trips)
      length                    = Decimal.new(:random.uniform(30))
      weight                    = Decimal.new(:random.uniform(5))
      {year, month, trip_start} = trip.start_date
      {_, _, trip_end}          = trip.end_date
      trip_length               = trip_end - trip_start
      day_caught                = :random.uniform(trip_length + 1) - 1
      date_caught               = {year, month, trip_start + day_caught}
      date_and_time_caught      = Ecto.DateTime.from_date_and_time(Ecto.Date.from_erl(date_caught), Ecto.Time.local())
      {:ok, date_and_time}      = Ecto.DateTime.dump(date_and_time_caught)

      Repo.insert %FishLanded{date_and_time: date_and_time, weight: weight, length: length, person_id: person.id, location_id: location.id, fly_type_id: fly.id}
    end)
  end
end

FishingSpot.Data.generate
