defmodule Day04 do
  @moduledoc """
  Dia 04 do Advent of Code 2024
  """
  @xmas ["X", "M", "A", "S"]

  def run(input_file) do

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

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "\n==Part 02== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  def part_01(puzzle) do
    Map.to_list(puzzle)
    |> Enum.filter(&(elem(&1, 1) == "X"))
    |> Enum.map(&(elem(&1, 0)))
    |> Enum.reduce(0, fn point, acc ->
      count_at_point(point, puzzle) + acc
    end)
  end

  def part_02(puzzle) do
    Map.to_list(puzzle)
    |> Enum.filter(&(elem(&1, 1) == "A"))
    |> Enum.map(&(elem(&1, 0)))
    |> Enum.count(&mas_point?(&1, puzzle))
  end

  def mas_point?({r, c}, puzzle) do
    mas_set = MapSet.new(["M", "A", "S"])

    right_diag_set =
      MapSet.new([
        Map.get(puzzle, {r - 1, c - 1}, ""),
        Map.get(puzzle, {r, c}, ""),
        Map.get(puzzle, {r + 1, c + 1}, "")
      ])

    left_diag_set =
      MapSet.new([
        Map.get(puzzle, {r + 1, c - 1}, ""),
        Map.get(puzzle, {r, c}, ""),
        Map.get(puzzle, {r - 1, c + 1}, "")
      ])

    MapSet.equal?(mas_set, right_diag_set) && MapSet.equal?(mas_set, left_diag_set)
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

# ---- Run
System.argv
|> hd
|> Day04.run