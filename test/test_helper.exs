Logger.configure(level: :info)
ExUnit.start

Mix.Task.run "ecto.create", ~w(-r FishingSpot.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r FishingSpot.Repo --quiet)

Ecto.Adapters.SQL.Sandbox.mode(FishingSpot.Repo, :manual)
