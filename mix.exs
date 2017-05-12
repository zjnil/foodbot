defmodule Foodbot.Mixfile do
  use Mix.Project

  def project do
    [app: :foodbot,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [mod: {Foodbot, []},
     applications: [:logger, :cowboy, :plug, :poison, :httpoison, :poolboy, :floki]]
  end

  defp deps do
    [{:cowboy, "~> 1.0"},
     {:plug, "~> 1.0"},
     {:poison, "~> 3.0"},
     {:httpoison, "~> 0.9"},
     {:poolboy, "~> 1.5"},
     {:floki, "~> 0.11"},
     {:distillery, "~> 0.10"}]
  end
end
