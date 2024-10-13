defmodule Day12 do
  @moduledoc """
  Dia 12 do Advent of Code de 2015
  """
  def run() do
    input_file = "input.txt"

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")

    {time, result} = :timer.tc(&part01/1, [input])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  # - Problema 01
  def part01(input) do
    Regex.scan(~r/-?\d+/, input)
    |> Enum.map(fn [x] -> String.to_integer(x) end)
    |> Enum.sum
  end
end
