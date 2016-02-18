defmodule FishingSpot.Test do
  use Ecto.Model

  @primary_key {:bigid, :id, autogenerate: true}

  schema "tests" do
    timestamps
  end
end
