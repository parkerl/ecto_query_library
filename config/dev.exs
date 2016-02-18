use Mix.Config
config :fishing_spot, FishingSpot.Repo,
    adapter: Ecto.Adapters.Postgres,
    database: "fishing_spot",
    username: "fishing_spot",
    password: "fishing_spot"
