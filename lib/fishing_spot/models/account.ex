defmodule FishingSpot.Account do
  use Ecto.Model

  schema "accounts" do
    timestamps
    field :identifier, :string
    field :name,       :string
  end
end
