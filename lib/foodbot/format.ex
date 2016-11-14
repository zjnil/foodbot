defmodule Foodbot.Format do
  def title(title) do
    title
    |> String.trim
    # remove leading dashes
    |> String.replace_prefix("-", "")
    # fix parenthesis
    |> String.replace("( ", "(")
    |> String.replace(" )", ")")
    # fix punctuation
    |> String.replace(~r/([,!.])/, "\\1 ")
    |> String.replace(~r/\s+([,!.])/, "\\1")
    # remove double spaces
    |> String.replace(~r{\s+}, " ")
    # remove the leftover spaces from previous operations
    |> String.trim
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
