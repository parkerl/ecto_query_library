defmodule FishingSpot.Mixfile do
  use Mix.Project

  def project do
    [app: :fishing_spot,
     version: "0.0.1",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     aliases: aliases(),
     docs: [earmark_plugins: %{"query" => FishingSpot.Doccer}]]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {FishingSpot, []},
     extra_applications: [:logger, :faker]]
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
    [{:postgrex, "~> 0.13"},
     {:ecto, "~> 2.2"},
     {:ex_doc, path: "../ex_doc"},
     {:faker, "~> 0.9"}]
  end

  defp aliases do
    ["ecto.rebuild": ["ecto.drop", "ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"]]
  end
end
