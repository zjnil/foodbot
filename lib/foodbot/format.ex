defmodule Foodbot.Format do
  def title(title) do
    title
    |> String.trim
    |> String.replace(",", ", ")
    |> String.replace(~r{\s+}u, " ")
    |> String.downcase
  end

  def price(price) do
    text =
      price
      |> String.trim_leading
      |> String.replace(",", ".")

    case Float.parse(text) do
      {float, _} -> float
      :error -> nil
    end
  end
end
