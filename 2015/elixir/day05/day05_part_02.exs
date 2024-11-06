defmodule Day05Part02 do
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
    contains_pair?(input_string) and
      contains_repeating_letter?(input_string)
  end

  # Checks if a string contains a pair of any two letters
  # that appears at least twice in the string without overlapping.
  def contains_pair?(input_string) do
    0..((input_string |> String.length()) - 2)
    |> Enum.any?(fn start_index ->
      pair = input_string |> String.slice(start_index..(start_index + 1))

      remaining_string = input_string |> String.slice((start_index + 2)..-1//1)
      String.contains?(remaining_string, pair)
    end)
  end

  # Checks if a string contains at least one letter
  # which repeats with exactly one letter between them
  def contains_repeating_letter?(input_string) do
    0..((input_string |> String.length()) - 3)
    |> Enum.any?(fn index ->
      String.at(input_string, index) == String.at(input_string, index + 2)
    end)
  end
end

# ---- Run

Day05Part02.run
|> IO.puts