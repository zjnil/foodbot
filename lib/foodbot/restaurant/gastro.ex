defmodule Foodbot.Restaurant.Gastro do
  alias Foodbot.Format

  def name, do: "Gastro House 151"
  def url, do: "http://www.gastrohouse.si/index.php/tedenska-ponudba"

  def process(%{body: body}, date) do
    body
    |> Floki.parse
    |> Floki.find(".futr")
    |> Enum.find(&menu_matches_date?(&1, date))
    |> process_menu
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
    |> Enum.reject(fn {_, price} -> price == nil end)
  end

  def process_item({"li", _, item_html}) do
    title_html = List.first(item_html)
    price_html = Floki.find(item_html, "span")
    title = Floki.text(title_html) |> Format.title
    price = Floki.text(price_html) |> Format.price
    {title, price}
  end

  def format_date({year, month, day}) do
    day = String.pad_leading("#{day}", 2, "0")
    month = String.pad_leading("#{month}", 2, "0")
    "#{day}.#{month}.#{year}"
  end
end
