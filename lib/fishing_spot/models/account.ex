defmodule FishingSpot.Account do
  use Ecto.Model
  import Ecto.Changeset

  schema "accounts" do
    timestamps
    field :identifier, :string
    field :name,       :string
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(identifier, name))
  end
end
