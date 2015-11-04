defmodule FishingSpot.Mixfile do
  use Mix.Project

  def project do
    [app: :fishing_spot,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     aliases: aliases,
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :postgrex, :ecto],
     mod: {FishingSpot, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:postgrex, ">= 0.9.1"},
      {:ecto, git: "https://github.com/elixir-lang/ecto.git"}
    ]
  end

  defp aliases do
    ["ecto.rebuild": ["ecto.drop", "ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"]]
  end
end
