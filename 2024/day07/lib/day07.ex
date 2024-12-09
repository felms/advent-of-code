defmodule Day07 do
  @moduledoc """
  Dia 07 do Advent of Code 2024
  """

  def run(mode \\ nil) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> parse_input

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  def part_01(input) do
    input
    |> Enum.filter(fn {test_value, [first_number | numbers]} ->
      can_be_made_true?(test_value, numbers, first_number)
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    line
    |> String.split(":", trim: true)
    |> then(&{&1 |> hd |> String.to_integer(), &1 |> tl |> parse_numbers})
  end

  def parse_numbers([numbers_str]) do
    numbers_str
    |> String.split(~r/\s+/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def can_be_made_true?(test_value, numbers_list, current_value)
  def can_be_made_true?(x, [], x), do: true
  def can_be_made_true?(_, [], _), do: false

  def can_be_made_true?(test_value, [current_number | numbers], current_value) do
    can_be_made_true?(test_value, numbers, current_number * current_value) ||
      can_be_made_true?(test_value, numbers, current_number + current_value)
  end
end
