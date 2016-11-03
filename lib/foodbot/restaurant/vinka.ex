defmodule Foodbot.Restaurant.Vinka do
  use GenServer
  alias Foodbot.Format

  @url "https://api.malcajt.com/getApiData.php?action=embed&id=1099&show=100"

  def name, do: "Vinka"

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
    |> Floki.find("#lunch ul")
    |> Enum.find(&menu_matches_date?(&1, date))
    |> process_menu
  end

  def menu_matches_date?(menu_html, date)
  when is_tuple(menu_html) do
    menu_html
    |> Floki.find(".day")
    |> Floki.text
    |> String.contains?(format_date(date))
  end

  def process_menu(menu_html)
  when is_tuple(menu_html) do
    menu_html
    |> Floki.find("li")
    |> Enum.drop(1)
    |> Enum.map(&process_item/1)
    |> Enum.reject(fn item -> item == nil end)
  end

  def process_item({"li", _, item}) do
    text = Floki.text(item)
    case Regex.scan(~r{\d+\) (.+) (\d+,\d+) (€|eur)}ui, text) do
      [[_, title, price | _rest]] ->
        {Format.title(title), Format.price(price)}
      [] ->
        nil
    end
  end

  def month_name({_year, month, _day}) do
    case month do
      1  -> "Januar"
      2  -> "Februar"
      3  -> "Marec"
      4  -> "April"
      5  -> "Maj"
      6  -> "Junij"
      7  -> "Julij"
      8  -> "Avgust"
      9  -> "September"
      10 -> "Oktober"
      11 -> "November"
      12 -> "December"
    end
  end

  def format_date({_year, _month, day} = date) do
    day = String.pad_leading("#{day}", 2, "0")
    "#{day}. #{month_name(date)}"
  end
end
