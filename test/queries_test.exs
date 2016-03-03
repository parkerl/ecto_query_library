defmodule FishingSpot.QueriesTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  ExUnit.configure(trace: true)

  alias FishingSpot.Queries
  alias FishingSpot.Repo
  alias FishingSpot.FishLanded

  setup do
   Repo.insert(%FishLanded{length: Decimal.new(1.0)})
   :ok
  end
  queries =  [
    &Queries.all_fishermen/0,
    &Queries.ordered_fishermen/0,
    &Queries.biggest_fish/0,
    &Queries.fishy_fish/0,
    &Queries.fisherman_by_keyword/0,
    &Queries.fishy_fish_count/0,
    &Queries.biggest_fish_per_fisherman/0,
    &Queries.biggest_fish_per_fisherman_ordered/0,
    &Queries.biggest_fish_per_fisherman_in_clause/0,
    &Queries.biggest_fish_per_fisherman_not_in_clause/0,
    &Queries.biggest_fish_per_fisherman_two_queries/0,
    &Queries.biggest_fish_catcher/0,
    &Queries.biggest_fish_catcher_in_clause/0,
    &Queries.biggest_fish_details/0,
    &Queries.complex_select_fragment/0,
    &Queries.fish_per_day/0,
    &Queries.composed_biggest_fish_details/0,
    &Queries.prefixed/0,
    &Queries.distinct_fish_weight/0,
    &Queries.distinct_fish_weight_with_expression/0,
    &Queries.distinct_fish_weight_with_order_by/0,
    &Queries.biggest_fish_per_fisherman_having/0,
    &Queries.all_fish_limit_10/0,
  ]

  Enum.each(queries, fn(query)->
    test "testing #{inspect(query)}" do
      capture_io(unquote(query))
    end
  end)
end
