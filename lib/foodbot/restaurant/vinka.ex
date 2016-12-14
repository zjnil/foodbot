defmodule Foodbot.Restaurant.Vinka do
  alias Foodbot.Format

  def name, do: "Vinka"
  def url, do: "https://api.malcajt.com/getApiData.php?action=embed&id=1099&show=100"

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
    |> Floki.text
    |> String.split("\n")
    |> Enum.drop(1)
    |> Enum.map(&process_item/1)
    |> Enum.reject(fn item -> item == nil end)
  end

  def process_item(text) do
    match_with_price(text) || match_without_price(text)
  end

  def match_with_price(text) do
    case Regex.run(~r{(\d+\))? (.+) (\d+,\d+)}, text) do
      [_, _, title, price] ->
        {Format.title(title), Format.price(price)}
      nil ->
        nil
    end
  end

  def match_without_price(text) do
    case Regex.run(~r{(\d+\))? (.+)}, text) do
      [_, _, title] ->
        {Format.title(title), nil}
      nil ->
        nil
    end
  end

  def month_name({_year, month, _day}) do
    case month do
      1  -> "Jan"
      2  -> "Feb"
      3  -> "Mar"
      4  -> "Apr"
      5  -> "Maj"
      6  -> "Jun"
      7  -> "Jul"
      8  -> "Avg"
      9  -> "Sep"
      10 -> "Okt"
      11 -> "Nov"
      12 -> "Dec"
    end
  end

  def format_date({_year, _month, day} = date) do
    day = String.pad_leading("#{day}", 2, "0")
    "#{day}. #{month_name(date)}"
  end
end
