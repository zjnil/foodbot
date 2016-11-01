defmodule Foodbot.Slack do
  alias Foodbot.Restaurant

  def command("help") do
    %{response_type: :ephemeral, text: help_text}
  end

  def command(all) when all in [nil, "", "all"] do
    text =
      Restaurant.fetch_all
      |> Enum.map(&format_response/1)
      |> Enum.join("\n\n")

    %{response_type: :in_channel, text: text}
  end

  def command(restaurant_name) do
    case Restaurant.find_restaurant(restaurant_name) do
      {:ok, restaurant} ->
        text =
          restaurant
          |> Restaurant.fetch
          |> format_response
        %{response_type: :in_channel, text: text}

      :error ->
        %{response_type: :ephemeral, text: help_text}
    end
  end

  def format_response({:ok, name, []}) do
    [format_title(name), "  • _No menu for today_"]
    |> Enum.join("\n")
  end

  def format_response({:ok, name, menu}) do
    [format_title(name) | Enum.map(menu, &format_item/1)]
    |> Enum.join("\n")
  end

  def format_response({:error, name, _}) do
    [format_title(name), "  • _Could not fetch today's menu_"]
    |> Enum.join("\n")
  end

  def format_title(name) do
    time = DateTime.utc_now |> DateTime.to_unix
    "*#{name}* (<!date^#{time}^{date_long}|Today>)"
  end

  def format_item({text, price}) do
    "  • #{text} #{format_price(price)}"
  end

  def format_price(nil), do: ""
  def format_price(price) do
    "*(#{Float.to_string(price, decimals: 2)}€)*"
  end

  def help_text do
    commands = Enum.join(all_commands, " | ")
    "Usage: /foodbot [#{commands}]"
  end

  def all_commands do
    ["help", "all" | Keyword.keys(Restaurant.restaurants)]
  end
end
