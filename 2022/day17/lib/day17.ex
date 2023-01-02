defmodule Day17 do
  @moduledoc """
  Documentation for `Day17`.
  """

  def part_01(input_file) do
    jets =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.graphemes()

    rocks = %{
      :horizontal => [{0, 0}, {0, 1}, {0, 2}, {0, 3}],
      :cross => [{0, 1}, {1, 0}, {1, 1}, {1, 2}, {2, 1}],
      :corner => [{0, 0}, {0, 1}, {0, 2}, {1, 2}, {2, 2}],
      :vertical => [{0, 0}, {1, 0}, {2, 0}, {3, 0}],
      :square => [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
    }

    initial_grid = MapSet.new([{0, 0}, {0, 1}, {0, 2}, {0, 3}, {0, 4}, {0, 5}, {0, 6}])

    drop_rock(rocks.horizontal, initial_grid)
  end

  def position_rock(rock, grid) do
    highest_row = grid_highest_row(grid)

    new_row = highest_row + 4
    new_col = 2

    rock
    |> Enum.map(fn {row, col} -> {row + new_row, col + new_col} end)
  end

  def grid_highest_row(grid) do
    grid
    |> MapSet.to_list()
    |> List.keysort(0, :desc)
    |> hd()
    |> elem(0)
  end

  def drop_rock(rock, grid) do

    rock_pos = position_rock(rock, grid)
    highest_row = grid_highest_row(grid)

    Enum.reduce_while(0..100, {rock_pos, grid}, fn _, acc ->
      {curr_rock, curr_grid} = acc

      IO.inspect(curr_rock)

      lowest_row =
        curr_rock
        |> List.keysort(0)
        |> hd() |> elem(0)

      if lowest_row - 1 === highest_row do
        new_grid = MapSet.union(grid, MapSet.new(curr_rock))
        {:halt, {curr_rock, new_grid}}
      else
        new_rock =
          curr_rock |> Enum.map(fn {row, col} -> {row - 1, col} end)
        {:cont, {new_rock, curr_rock}}
      end

    end)

  end

end
