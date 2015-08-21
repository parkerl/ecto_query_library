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

    {:ok, rainbow_trout  } = Repo.insert %FishSpecies{  name: "Rainbow Trout"   }
    {:ok, brown_trout    } = Repo.insert %FishSpecies{  name: "Brown Trout"     }
    {:ok, lake_trout     } = Repo.insert %FishSpecies{  name: "Lake Trout"      }
    {:ok, brook_trout    } = Repo.insert %FishSpecies{  name: "Brook Trout"     }
    {:ok, cutthroat_trout} = Repo.insert %FishSpecies{  name: "Cutthroat Trout" }

    fish_types = [rainbow_trout, brown_trout, lake_trout, brook_trout, cutthroat_trout]

    {:ok, muddler}      = Repo.insert %FlyType{  name: "Muddler Minnow" }
    {:ok, hairs_ear}    = Repo.insert %FlyType{  name: "Hairs Ear"      }
    {:ok, copper_john } = Repo.insert %FlyType{  name: "Copper John"    }
    {:ok, royal_wulff } = Repo.insert %FlyType{  name: "Royal Wulff"    }
    {:ok, morning_dunn} = Repo.insert %FlyType{  name: "Morning Dunn"   }

    flies = [muddler, hairs_ear, copper_john, royal_wulff, morning_dunn]

    {:ok, lake        } = Repo.insert %LocationType{  name: "Lake"         }
    {:ok, pond        } = Repo.insert %LocationType{  name: "Pond"         }
    {:ok, spring_creek} = Repo.insert %LocationType{  name: "Spring Creek" }
    {:ok, stream      } = Repo.insert %LocationType{  name: "Stream"       }
    {:ok, river       } = Repo.insert %LocationType{  name: "River"        }
    {:ok, tail_water  } = Repo.insert %LocationType{  name: "Tail Water"   }

    {:ok, mark }= Repo.insert %Person{ name: "Mark",  date_of_birth: %Ecto.Date{ year: 1970,  month: 1,   day:  2 }}
    {:ok, kirk }= Repo.insert %Person{ name: "Kirk",  date_of_birth: %Ecto.Date{ year: 1978,  month: 3,   day:  5 }}
    {:ok, joe  }= Repo.insert %Person{ name: "Joe",   date_of_birth: %Ecto.Date{ year: 1973,  month: 10,  day: 15 }}
    {:ok, lew  }= Repo.insert %Person{ name: "Lew",   date_of_birth: %Ecto.Date{ year: 1976,  month: 1,   day:  5 }}

    people = [mark, kirk, joe, lew]

    {:ok, trip1}  = Repo.insert %Trip{ start_date: %Ecto.Date{ year: 2012,  month: 6,  day: 5 }, end_date: %Ecto.Date{ year: 2012,  month: 6,  day: 12 }}
    {:ok, trip2}  = Repo.insert %Trip{ start_date: %Ecto.Date{ year: 2012,  month: 10,  day: 15 }, end_date: %Ecto.Date{ year: 2012,  month: 10,  day: 20 }}
    {:ok, trip3}  = Repo.insert %Trip{ start_date: %Ecto.Date{ year: 2013,  month: 9,  day: 1 }, end_date: %Ecto.Date{ year: 2013,  month: 9,  day: 2 }}
    {:ok, trip4}  = Repo.insert %Trip{ start_date: %Ecto.Date{ year: 2014,  month: 7,  day: 15 }, end_date: %Ecto.Date{ year: 2014,  month: 7,  day: 20 }}
    {:ok, trip5}  = Repo.insert %Trip{ start_date: %Ecto.Date{ year: 2014,  month: 8,  day: 8 }, end_date: %Ecto.Date{ year: 2014,  month: 8,  day: 18 }}

    trips = [trip1, trip2, trip3, trip4, trip5]

    {:ok, lake_fork  } = Repo.insert %Location{name: "Lake Fork",               altitude: 8000,  lat: Decimal.new(38.090942),  long: Decimal.new(-107.292869),  location_type_id: river.id        }
    {:ok, blue_mesa  } = Repo.insert %Location{name: "Blue Mesa",               altitude: 7000,  lat: Decimal.new(38.472406),  long: Decimal.new(-107.210268),  location_type_id: lake.id         }
    {:ok, main_elk   } = Repo.insert %Location{name: "Main Elk Creek",          altitude: 7000,  lat: Decimal.new(39.729579),  long: Decimal.new(-107.545462),  location_type_id: spring_creek.id }
    {:ok, frying_pan } = Repo.insert %Location{name: "Frying Pan Tailwater",    altitude: 6000,  lat: Decimal.new(39.363448),  long: Decimal.new(-106.823121),  location_type_id: tail_water.id   }
    {:ok, unamed_pond} = Repo.insert %Location{name: "Unamed Pond",             altitude: 5000,  lat: Decimal.new(39.887929),  long: Decimal.new(-107.354998),  location_type_id: pond.id         }
    {:ok, white_river} = Repo.insert %Location{name: "North Fork White River",  altitude: 5000,  lat: Decimal.new(40.051879),  long: Decimal.new(-107.458016),  location_type_id: pond.id         }

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

    Repo.insert %PersonTrip{person_id: lew.id  , trip_id: trip1.id}
    Repo.insert %PersonTrip{person_id: lew.id  , trip_id: trip2.id}
    Repo.insert %PersonTrip{person_id: lew.id  , trip_id: trip3.id}
    Repo.insert %PersonTrip{person_id: lew.id  , trip_id: trip4.id}
    Repo.insert %PersonTrip{person_id: lew.id  , trip_id: trip5.id}
    Repo.insert %PersonTrip{person_id: kirk.id , trip_id: trip4.id}
    Repo.insert %PersonTrip{person_id: kirk.id , trip_id: trip5.id}
    Repo.insert %PersonTrip{person_id: joe.id  , trip_id: trip1.id}
    Repo.insert %PersonTrip{person_id: joe.id  , trip_id: trip5.id}
    Repo.insert %PersonTrip{person_id: mark.id , trip_id: trip1.id}
    Repo.insert %PersonTrip{person_id: mark.id , trip_id: trip2.id}
    Repo.insert %PersonTrip{person_id: mark.id , trip_id: trip3.id}

    :random.seed(:erlang.now)

    Enum.each(1..1000, fn(_) ->
      [person  |_]              = Enum.shuffle(people)
      [location|_]              = Enum.shuffle(locations)
      [fly     |_]              = Enum.shuffle(flies)
      [trip    |_]              = Enum.shuffle(trips)
      [fish    |_]              = Enum.shuffle(fish_types)
      length                    = Decimal.new(:random.uniform(30))
      weight                    = Decimal.new(:random.uniform(5))
      {year, month, trip_start} = trip.start_date
      {_, _, trip_end}          = trip.end_date
      trip_length               = trip_end - trip_start
      day_caught                = :random.uniform(trip_length + 1) - 1
      date_caught               = {year, month, trip_start + day_caught}
      date_and_time_caught      = Ecto.DateTime.from_date_and_time(Ecto.Date.from_erl(date_caught), Ecto.Time.local())
      {:ok, date_and_time}      = Ecto.DateTime.dump(date_and_time_caught)

      Repo.insert %FishLanded{date_and_time: date_and_time, weight: weight, length: length, person_id: person.id, location_id: location.id, fly_type_id: fly.id, fish_species_id: fish.id}
    end)

      [location|_]              = Enum.shuffle(locations)
      [fly     |_]              = Enum.shuffle(flies)
      [trip    |_]              = Enum.shuffle(trips)
      [fish    |_]              = Enum.shuffle(fish_types)
      {year, month, trip_start} = trip.start_date
      {_, _, trip_end}          = trip.end_date
      trip_length               = trip_end - trip_start
      day_caught                = :random.uniform(trip_length + 1) - 1
      date_caught               = {year, month, trip_start + day_caught}
      date_and_time_caught      = Ecto.DateTime.from_date_and_time(Ecto.Date.from_erl(date_caught), Ecto.Time.local())
      {:ok, date_and_time}      = Ecto.DateTime.dump(date_and_time_caught)
      Repo.insert %FishLanded{date_and_time: date_and_time, weight: Decimal.new(:random.uniform(50)), length: Decimal.new(:random.uniform(100)), person_id: mark.id, location_id: location.id, fly_type_id: fly.id, fish_species_id: fish.id}
      [location|_]              = Enum.shuffle(locations)
      [fly     |_]              = Enum.shuffle(flies)
      [trip    |_]              = Enum.shuffle(trips)
      [fish    |_]              = Enum.shuffle(fish_types)
      {year, month, trip_start} = trip.start_date
      {_, _, trip_end}          = trip.end_date
      trip_length               = trip_end - trip_start
      day_caught                = :random.uniform(trip_length + 1) - 1
      date_caught               = {year, month, trip_start + day_caught}
      date_and_time_caught      = Ecto.DateTime.from_date_and_time(Ecto.Date.from_erl(date_caught), Ecto.Time.local())
      {:ok, date_and_time}      = Ecto.DateTime.dump(date_and_time_caught)
      Repo.insert %FishLanded{date_and_time: date_and_time, weight: Decimal.new(:random.uniform(50)), length: Decimal.new(:random.uniform(100)), person_id: kirk.id, location_id: location.id, fly_type_id: fly.id, fish_species_id: fish.id}
      [location|_]              = Enum.shuffle(locations)
      [fly     |_]              = Enum.shuffle(flies)
      [trip    |_]              = Enum.shuffle(trips)
      [fish    |_]              = Enum.shuffle(fish_types)
      {year, month, trip_start} = trip.start_date
      {_, _, trip_end}          = trip.end_date
      trip_length               = trip_end - trip_start
      day_caught                = :random.uniform(trip_length + 1) - 1
      date_caught               = {year, month, trip_start + day_caught}
      date_and_time_caught      = Ecto.DateTime.from_date_and_time(Ecto.Date.from_erl(date_caught), Ecto.Time.local())
      {:ok, date_and_time}      = Ecto.DateTime.dump(date_and_time_caught)
      Repo.insert %FishLanded{date_and_time: date_and_time, weight: Decimal.new(:random.uniform(50)), length: Decimal.new(:random.uniform(100)), person_id: lew.id, location_id: location.id, fly_type_id: fly.id, fish_species_id: fish.id}
      [location|_]              = Enum.shuffle(locations)
      [fly     |_]              = Enum.shuffle(flies)
      [trip    |_]              = Enum.shuffle(trips)
      [fish    |_]              = Enum.shuffle(fish_types)
      {year, month, trip_start} = trip.start_date
      {_, _, trip_end}          = trip.end_date
      trip_length               = trip_end - trip_start
      day_caught                = :random.uniform(trip_length + 1) - 1
      date_caught               = {year, month, trip_start + day_caught}
      date_and_time_caught      = Ecto.DateTime.from_date_and_time(Ecto.Date.from_erl(date_caught), Ecto.Time.local())
      {:ok, date_and_time}      = Ecto.DateTime.dump(date_and_time_caught)
      Repo.insert %FishLanded{date_and_time: date_and_time, weight: Decimal.new(:random.uniform(50)), length: Decimal.new(:random.uniform(100)), person_id: joe.id, location_id: location.id, fly_type_id: fly.id, fish_species_id: fish.id}
  end
end

FishingSpot.Data.generate
