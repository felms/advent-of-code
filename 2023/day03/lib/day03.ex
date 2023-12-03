defmodule Day03 do
  @moduledoc """
  Dia 02 do Advent of Code 2023
  """

  # the bag contains only 12 red cubes, 13 green cubes, and 14 blue cubes
  @max_cubes %{red: 12, green: 13, blue: 14}

  def run(mode \\ :real_input) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> parse_input()

    # {time, result} = :timer.tc(&part_01/1, [input])

    # IO.puts(
    #   "==Part 01== \nResult: #{result}" <>
    #     "\nCalculated in #{time / 1_000_000} seconds\n"
    # )

    # {time, result} = :timer.tc(&part_02/1, [input])

    # IO.puts(
    #   "==Part 02== \nResult: #{result}" <>
    #     "\nCalculated in #{time / 1_000_000} seconds\n"
    # )
  end

  def parse_input(input) do
    points =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    grid_rows = points |> length
    grid_columns = points |> hd |> length

    grid_indexes =
      for row <- 0..(grid_rows - 1), do: for(column <- 0..(grid_columns - 1), do: {row, column})

    Enum.zip(
      List.flatten(grid_indexes),
      List.flatten(points)
    )
    |> Enum.into(%{})
  end
end
