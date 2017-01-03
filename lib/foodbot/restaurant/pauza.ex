defmodule Foodbot.Restaurant.Pauza do
  alias Foodbot.Format

  def name, do: "Pauza"
  def url, do: "http://www.pauza.si/52-dnevne-malice"

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
    |> String.contains?(format_date(date))
  end

  def process_menu(menu_html) do
    menu_html
    |> Floki.find("tr")
    |> Enum.filter(&is_menu_item?/1)
    |> Enum.reject(&is_additional_text?/1)
    |> Enum.map(&process_item/1)
    |> Enum.reject(fn {title, _} -> title == "" end)
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

  def format_date({_, month, day}) do
    day = String.pad_leading("#{day}", 2, "0")
    month = String.pad_leading("#{month}", 2, "0")
    "#{day}.#{month}"
  end
end
