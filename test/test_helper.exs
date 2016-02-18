Logger.configure(level: :info)
ExUnit.start

# Configure Ecto for support and tests
Application.put_env(:ecto, :lock_for_update, "FOR UPDATE")
Application.put_env(:ecto, :primary_key_type, :id)

# Configure PG connection
Application.put_env(:ecto, :pg_test_url,
                    "ecto://" <> (System.get_env("PG_URL") || "postgres:postgres@localhost")
)


pool =
  case System.get_env("ECTO_POOL") || "poolboy" do
    "poolboy"        -> DBConnection.Poolboy
    "sojourn_broker" -> DBConnection.Sojourn
  end

# Pool repo for async, safe tests
alias FishingSpot.Repo

Application.put_env(:ecto, Repo,
                    adapter: Ecto.Adapters.Postgres,
                    url: Application.get_env(:ecto, :pg_test_url) <> "/ecto_test",
                    pool: Ecto.Adapters.SQL.Sandbox,
                    ownership_pool: pool)


defmodule Ecto.Integration.Case do
  use ExUnit.CaseTemplate

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end
end

{:ok, _} = Application.ensure_all_started(:postgrex)

_   = Ecto.Storage.down(Repo)
:ok = Ecto.Storage.up(Repo)

Mix.Task.run "ecto.create", ~w(-r FishingSpot.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r FishingSpot.Repo --quiet)

Process.flag(:trap_exit, true)
