defmodule Foodbot.Restaurant do
  def fetch(restaurant, date \\ today) do
    name = restaurant.name
    try do
      menu = GenServer.call(restaurant, {:fetch, date})
      {:ok, name, menu}
    catch
      :exit, _ -> {:error, name, :crashed}
    end
  end

  def fetch_all(date \\ today) do
    restaurants
    |> Keyword.values
    |> Enum.map(&Task.async(fn -> fetch(&1, date) end))
    |> Enum.map(&Task.await(&1))
  end

  def find_restaurant(name) when is_atom(name) do
    Keyword.fetch(restaurants, name)
  end

  def find_restaurant(name) when is_binary(name) do
    result = Enum.find(restaurants, fn {k, _} -> Atom.to_string(k) == name end)
    case result do
      nil        -> :error
      {_, value} -> {:ok, value}
    end
  end

  def restaurants, do: Application.get_env(:foodbot, :restaurants)
  def today, do: elem(:calendar.local_time(), 0)
end
