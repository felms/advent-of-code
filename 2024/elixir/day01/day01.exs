defmodule Day01 do
  @moduledoc """
  Dia 01 do Advent of Code 2024
  """

  def run(input_file) do

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
    |> Enum.map(fn line -> line |> String.split() |> Enum.map(&String.to_integer/1) end)
    |> Enum.zip()
    |> Enum.map(&(&1 |> Tuple.to_list() |> Enum.sort()))
  end

  def part_01(lists) do
    lists
    |> Enum.zip()
    |> Enum.reduce(0, fn {a, b}, acc -> acc + abs(a - b) end)
  end

  def part_02([first_list, second_list]) do
    first_list
    |> Enum.reduce(0, fn number, acc ->
      Enum.count(second_list, &(&1 == number)) * number + acc
    end)
  end
end

# ---- Run
System.argv
|> hd
|> Day01.run