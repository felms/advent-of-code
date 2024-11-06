defmodule Day05 do
  @moduledoc """
  Dia 05 do Advent of Code de 2015
  """

  def run(input \\ "input.txt") do
    File.read!(input)
    # Para evitar problemas no Windows
    |> String.replace("\r", "")
    |> String.trim()
    |> String.split("\n")
    |> Enum.count(&is_nice?/1)
  end

  # Checks if a string is "nice"
  def is_nice?(input_string) do
    contains_three_vowels?(input_string) and
      contains_twice_in_a_row_letters?(input_string) and
      not contains_disallowed_strings?(input_string)
  end

  # Checks if a string contains at least three vowels
  def contains_three_vowels?(input_string) do
    input_string
    |> String.graphemes()
    |> Enum.filter(fn letter -> letter in ["a", "e", "i", "o", "u"] end)
    |> Enum.count()
    |> Kernel.>=(3)
  end

  # Checks if a string contains at least one letter that appears twice in a row
  def contains_twice_in_a_row_letters?(input_string) do
    input_string
    |> String.graphemes()
    |> Enum.any?(fn letter -> String.contains?(input_string, String.duplicate(letter, 2)) end)
  end

  # Checks if the string does not contain the strings ab, cd, pq, or xy
  def contains_disallowed_strings?(input_string) do
    input_string
    |> String.contains?(["ab", "cd", "pq", "xy"])
  end
end

# ---- Run

Day05.run
|> IO.puts