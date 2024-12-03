defmodule Day03 do
  @moduledoc """
  Dia 03 do Advent of Code 2024
  """

  def run(mode \\ nil) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.replace("\n", "") # Essa merda me fez perder meio dia (!!!)

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

  def part_01(input) do
    Regex.scan(~r/mul\((\d+),(\d+)\)/, input)
    |> Enum.reduce(0, fn [_, a, b], acc -> acc + String.to_integer(a) * String.to_integer(b) end)
  end

  def part_02(input) do
    Regex.scan(~r/^(.*?)don't\(\)|do\(\)(.*?)don't\(\)/, input)
    |> Enum.map(fn [_ | rest] -> Enum.join(rest, "") end)
    |> Enum.join()
    |> part_01
  end
end
