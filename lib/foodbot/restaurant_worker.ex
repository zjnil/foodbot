defmodule Foodbot.Restaurant.Worker do
  use GenServer

  def start_link, do: start_link([])
  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def handle_call({:fetch, restaurant, date}, _from, state) do
    menu =
      restaurant
      |> fetch
      |> restaurant.process(date)
    {:reply, menu, state}
  end

  def fetch(restaurant) do
    HTTPoison.get!(restaurant.url, [], follow_redirect: true)
  end
end
