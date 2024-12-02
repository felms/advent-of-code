defmodule Day02 do
  @moduledoc """
  Dia 02 do Advent of Code 2024
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
  end

  def part_01(input), do: input |> Enum.count(&(safe_decreasing?(&1) || safe_increasing?(&1)))

  def part_02(input), do: input |> Enum.count(&safe_with_tolerance?/1)

  def safe_with_tolerance?(input) do
    safe_increasing?(input) || safe_decreasing?(input) ||
      0..(length(input) - 1)
      |> Enum.any?(fn i -> input |> List.delete_at(i) |> safe_increasing? end) ||
      0..(length(input) - 1)
      |> Enum.any?(fn i -> input |> List.delete_at(i) |> safe_decreasing? end)
  end

  def safe_increasing?(report_line) do
    report_line
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> b - a >= 1 && b - a <= 3 end)
  end

  def safe_decreasing?(report_line) do
    report_line
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> a - b >= 1 && a - b <= 3 end)
  end
end

# ---- Run
System.argv
|> hd
|> Day02.run
