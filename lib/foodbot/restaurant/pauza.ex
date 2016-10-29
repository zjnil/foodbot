defmodule Foodbot.Restaurant.Pauza do
  use GenServer
  alias Foodbot.Format

  @url "http://www.pauza.si/52-dnevne-malice"

  def name, do: "Pauza"

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
    |> Floki.find("article table")
    |> ensure_correct_date(date)
    |> process_menu
  end

  def ensure_correct_date(menu_html, date) do
    true = menu_for_correct_date?(menu_html, date)
    menu_html
  end

  def menu_for_correct_date?(menu_html, date) do
    menu_html
    |> Floki.find("h1")
    |> Floki.text
    |> String.contains?(formatted_date(date))
  end

  def process_menu(menu_html) do
    menu_html
    |> Floki.find("tr")
    |> Enum.filter(&is_menu_item?/1)
    |> Enum.reject(&is_additional_text?/1)
    |> Enum.map(&process_item/1)
  end

  def is_menu_item?({"tr", [], tds}) do
    Enum.count(tds) == 3
  end

  def is_additional_text?(menu_item) do
    menu_item
    |> Floki.text
    |> String.contains?("059-033-001")
  end

  def process_item({"tr", [], [html_title, _, html_price]}) do
    title = Floki.text(html_title) |> Format.title
    price = Floki.text(html_price) |> Format.price
    {title, price}
  end

  def formatted_date({y, m, d}), do: "#{d}.#{m}.#{y}"
end
