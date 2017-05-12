defmodule Foodbot.Restaurant.Kulinarija do
  alias Foodbot.Format

  def name, do: "D·Labs Kulinarija"
  def url, do: "https://drive.google.com/uc?export=download&id=0B6hU-wFCt6IRZEpiZW0zWUlDNFk"

  def process(%{body: body}, _date) do
    html = Floki.parse(body)
    menu = process_menu(html)
    date = process_date(html)
    {menu, date}
  end

  def process_menu(menu_html) do
    menu_html
    |> Floki.find("p")
    |> Enum.map(&process_item/1)
  end

  def process_item({"p", _, item_html}) do
    title = Floki.text(item_html) |> Format.title
    {title, nil}
  end

  def process_date(menu_html) do
    date_text = Floki.find(menu_html, "h2") |> Floki.text

    [day, month, year] = String.split(date_text, ".")
    day = day |> String.trim |> String.to_integer
    month = month |> String.trim |> String.to_integer
    year = year |> String.trim |> String.to_integer

    date = DateTime.utc_now
    %{date | day: day, month: month, year: year}
  end
end
