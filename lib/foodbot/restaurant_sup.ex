defmodule Foodbot.Restaurant.Supervisor do
  use Supervisor
  alias Foodbot.Restaurant

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    restaurants = Restaurant.restaurants
    children = for {_, restaurant} <- restaurants, do: worker(restaurant, [])
    supervise(children, strategy: :one_for_one)
  end
end
