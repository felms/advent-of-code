defmodule Day03 do
  @moduledoc """
  Dia 03 do Advent of Code 2022
  """

  # ======= Problema 01 - Priorizar os items
  def sum_of_priorities do

    File.read!("./input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn rucksack -> String.split_at(rucksack, div(String.length(rucksack), 2)) end)
    |> Enum.map(fn rucksack -> repeated_items_priorities(rucksack) end)
    |> Enum.sum

  end

  defp repeated_items_priorities({first_rucksack, second_rucksack}) do
    alphabet = String.graphemes("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

    String.graphemes(first_rucksack)
    |> Enum.filter(fn item -> String.contains?(second_rucksack, item) end)
    |> Enum.uniq
    |> Enum.map(fn item -> Enum.find_index(alphabet, fn letter -> letter === item end) + 1 end)
    |> hd

  end

end
