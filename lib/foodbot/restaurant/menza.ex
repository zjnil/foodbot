defmodule Foodbot.Restaurant.Menza do
  alias Foodbot.Format

  def name, do: "WTC Menza"
  def url, do: "http://www.femec.si/poslovne-enote/"

  def process(%{body: body}, date) do
    body
    |> Floki.parse
    |> Floki.find("##{week_day(date)} .menucontent")
    |> process_menu
  end

  def process_menu(menu_html) do
    menu_html
    |> Enum.map(&process_item/1)
  end

  def process_item({"div", _, list}) do
    title =
      list
      |> Enum.flat_map(fn p -> String.split(Floki.text(p), "\n") end)
      |> Enum.drop(1)
      |> Enum.reject(&is_blank?/1)
      |> Enum.reject(&is_generic?/1)
      |> Enum.join(", ")
      |> Format.title

    {title, nil}
  end

  def is_generic?(text) do
    String.match?(text, ~r{solatni bife|dnevna sladica}i)
  end

  def is_blank?(text) do
    String.strip(text) == ""
  end

  def week_day({y, m, d}) do
    case :calendar.day_of_the_week(y, m, d) do
      1 -> "ponedeljek"
      2 -> "torek"
      3 -> "sreda"
      4 -> "cetrtek"
      5 -> "petek"
    end
  end
end
