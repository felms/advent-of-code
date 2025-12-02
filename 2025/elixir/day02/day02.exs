defmodule Day02 do
  @moduledoc """
  Dia 02 do Advent of Code 2025
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
    |> String.split(",", trim: true)
    |> Enum.map(&parse_range/1)
  end

  def parse_range(range) do
    Regex.run(~r/(\d+)-(\d+)/, range)
    |> tl
    |> Enum.map(&String.to_integer/1)
    |> range_to_list
  end

  def range_to_list([first, last]), do: Enum.to_list(first..last) |> Enum.map(&Integer.to_string/1)

  def invalid?(input) do
    input
    |> String.split_at(div(String.length(input), 2))
    |> Tuple.to_list
    |> then(fn x -> length(Enum.uniq(x)) == 1 end)
  end

  def part_01(input) do
    input
    |> Enum.map(&(Enum.filter(&1, fn x -> invalid?(x) end)))
    |> Enum.map(fn x -> x |> Enum.map(&String.to_integer/1) |> Enum.sum end)
    |> Enum.sum
  end

end

# ---- Run
System.argv
|> hd
|> Day02.run
