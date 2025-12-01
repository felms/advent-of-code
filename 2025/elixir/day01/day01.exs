
defmodule Day01 do
  @moduledoc """
  Dia 01 do Advent of Code 2025
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

  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_rotation/1)
  end

  def part_01(rotations) do
    rotations
    |> Enum.reduce({50, 0}, fn rotation, {curr_dial, curr_count} -> 
      case execute_rotation(curr_dial, rotation) do
        0 -> {0, curr_count + 1}
        x -> {x, curr_count}
      end
    end)
    |> elem(1)
  end

  def parse_rotation(rotation) do
    Regex.run(~r/(R|L)(\d+)/, rotation)
    |> then(fn [_, direction, distance] -> {direction, String.to_integer(distance)} end)
  end

  def execute_rotation(dial_value, rotation) do
    case rotation do
      {"R", distance} -> (dial_value + distance) |> rem(100)
      {"L", distance} -> (dial_value - distance) + 100 |> rem(100)
        _ -> :error
    end
  end

end

# ---- Run
System.argv
|> hd
|> Day01.run
