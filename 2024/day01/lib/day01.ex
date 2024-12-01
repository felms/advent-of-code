defmodule Day01 do
  @moduledoc """
  Dia 01 do Advent of Code 2024
  """

  def run(mode \\ nil) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> parse_input()

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "\n==Part 02== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.reduce([[], []], fn [a, b], [first_list, second_list] ->
      [[String.to_integer(a) | first_list], [String.to_integer(b) | second_list]]
    end)
    |> then(fn [a, b] -> [Enum.sort(a), Enum.sort(b)] end)
  end

  def part_01([first_list, second_list]) do
    0..(length(first_list) - 1)
    |> Enum.reduce(0, fn index, acc ->
      acc + abs(Enum.at(first_list, index) - Enum.at(second_list, index))
    end)
  end

  def part_02([first_list, second_list]) do
    first_list
    |> Enum.reduce(0, fn number, acc ->
      Enum.count(second_list, &(&1 == number)) * number + acc
    end)
  end
end
