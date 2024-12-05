defmodule Day04 do
  @moduledoc """
  Dia 04 do Advent of Code 2024
  """
  @xmas ["X", "M", "A", "S"]

  def run(mode \\ nil) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)
      |> parse_input

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  def part_01(puzzle) do
    points =
      Map.to_list(puzzle)
      |> Enum.filter(fn {_point, letter} -> letter == "X" end)
      |> Enum.map(fn {point, _letter} -> point end)

    points
    |> Enum.reduce(0, fn point, acc ->
      if Map.get(puzzle, point) == "X", do: count_at_point(point, puzzle) + acc, else: acc
    end)
  end

  def count_at_point(point, puzzle) do
    horizontal =
      count(
        [[{0, 0}, {0, 1}, {0, 2}, {0, 3}], [{0, 0}, {0, -1}, {0, -2}, {0, -3}]],
        point,
        puzzle
      )

    vertical =
      count(
        [[{0, 0}, {1, 0}, {2, 0}, {3, 0}], [{0, 0}, {-1, 0}, {-2, 0}, {-3, 0}]],
        point,
        puzzle
      )

    right_diag =
      count(
        [[{0, 0}, {1, 1}, {2, 2}, {3, 3}], [{0, 0}, {-1, -1}, {-2, -2}, {-3, -3}]],
        point,
        puzzle
      )

    left_diag =
      count(
        [[{0, 0}, {1, -1}, {2, -2}, {3, -3}], [{0, 0}, {-1, 1}, {-2, 2}, {-3, 3}]],
        point,
        puzzle
      )

    horizontal + vertical + right_diag + left_diag
  end

  def count([points_before, points_after], {r, c}, puzzle) do
    lb =
      points_before
      |> Enum.map(fn {dR, dC} -> Map.get(puzzle, {r + dR, c + dC}, "") end)

    la =
      points_after
      |> Enum.map(fn {dR, dC} -> Map.get(puzzle, {r + dR, c + dC}, "") end)

    cb = if lb == @xmas, do: 1, else: 0
    ca = if la == @xmas, do: 1, else: 0

    cb + ca
  end

  def parse_input(input) do
    input
    |> Enum.with_index()
    |> Enum.map(&parse_row/1)
    |> List.flatten()
    |> Map.new()
  end

  def parse_row({row, row_number}) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {item, col_number} -> {{row_number, col_number}, item} end)
  end
end
