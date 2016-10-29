defmodule Foodbot.Restaurant.Gastro do
  use GenServer
  alias Foodbot.Format

  @url "http://www.gastrohouse.si/index.php/tedenska-ponudba"

  def name, do: "Gastro House 151"

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle_call({:fetch, date}, _from, state) do
    menu = fetch |> process(date)
    {:reply, menu, state}
  end

  def fetch do
    HTTPoison.get!(@url)
  end

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
    |> String.contains?(formatted_date(date))
  end

  def process_menu(menu_html)
  when is_tuple(menu_html) do
    menu_html
    |> Floki.find("li")
    |> Enum.map(&process_item/1)
  end

  def process_item({"li", _, [html_title, html_price]}) do
    title = Floki.text(html_title) |> Format.title
    price = Floki.text(html_price) |> Format.price
    {title, price}
  end

  def formatted_date({y, m, d}), do: "#{d}.#{m}.#{y}"
end
