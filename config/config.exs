# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :foodbot, :port, {:system, "PORT", 4000}

config :foodbot, restaurants: [
  gastro: Foodbot.Restaurant.Gastro,
  menza: Foodbot.Restaurant.Menza,
  pauza: Foodbot.Restaurant.Pauza,
  vinka: Foodbot.Restaurant.Vinka,
  kulinarnia: Foodbot.Restaurant.Kulinarnia
]

import_config "#{Mix.env}.exs"
