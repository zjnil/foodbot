defmodule Foodbot.Restaurant.Gastro do
  alias Foodbot.Format

  def name, do: "Gastro House 151"
  def url, do: "http://www.gastrohouse.si/index.php/tedenska-ponudba"

  def process(%{body: body}, date) do
    menu =
      body
      |> Floki.parse
      |> Floki.find(".futr")
      |> Enum.find(&menu_matches_date?(&1, date))
      |> process_menu
    {menu, date}
  end

  def menu_matches_date?(menu_html, date)
  when is_tuple(menu_html) do
    menu_html
    |> Floki.find(".naslov")
    |> Floki.text
    |> String.contains?(format_date(date))
  end

  def process_menu(menu_html)
  when is_tuple(menu_html) do
    menu_html
    |> Floki.find("li")
    |> Enum.map(&process_item/1)
    |> Enum.reject(fn item -> item == nil end)
  end

  def process_item({"li", _, item_html}) do
    text = Floki.text(item_html)
    case Regex.run(~r{(.+)\s+(\d+,\d+)}u, text) do
      [_, title, price] ->
        {Format.title(title), Format.price(price)}
      nil ->
        nil
    end
  end

  def format_date(date) do
    day = String.pad_leading("#{date.day}", 2, "0")
    month = String.pad_leading("#{date.month}", 2, "0")
    year = date.year
    "#{day}.#{month}.#{year}"
  end
end
