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

    {_new_rock, new_grid, _new_move, new_jets} =
      drop_rock(rocks.horizontal, initial_grid, jets)

    {_, res, _, _} =
      drop_rock(rocks.cross, new_grid, new_jets)

    res

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

  def drop_rock(rock, grid, jets) do

    rock_pos = position_rock(rock, grid)
    highest_row = grid_highest_row(grid)
    move = :horizontal

    Enum.reduce_while(0..100, {rock_pos, grid, move, jets}, fn _, acc ->
      {curr_rock, curr_grid, curr_move, curr_jets} = acc

      lowest_row =
        curr_rock
        |> List.keysort(0)
        |> hd() |> elem(0)

      if lowest_row - 1 === highest_row and curr_move === :vertical do
        new_grid = MapSet.union(grid, MapSet.new(curr_rock))
        {:halt, {curr_rock, new_grid, curr_move, curr_jets}}
      else
        {new_rock, new_move, new_jets} = move_rock(curr_rock, curr_move, curr_jets)
        {:cont, {new_rock, curr_grid, new_move, new_jets}}
      end

    end)

  end

  def move_rock(rock, move, jets) do
    if move === :vertical do
      new_rock = rock |> Enum.map(fn {row, col} -> {row - 1, col} end)
      new_move = :horizontal
      {new_rock, new_move, jets}
    else
      {direction, remaining_jets} = List.pop_at(jets, 0)
      new_jets = List.insert_at(remaining_jets, -1, direction)
      new_move = :vertical
      new_rock = lateral_move(rock, direction)
      {new_rock, new_move, new_jets}
    end
  end

  def lateral_move(rock, direction) do

    cond do
      direction === "<" and leftmost_column(rock) > 0 ->
        rock |> Enum.map(fn {row, column} -> {row, column - 1} end)
      direction === ">" and rightmost_column(rock) < 6 ->
        rock |> Enum.map(fn {row, column} -> {row, column + 1} end)
      true -> rock
    end

  end

  def leftmost_column(rock) do
    rock |> List.keysort(1) |> hd() |> elem(1)
  end

  def rightmost_column(rock) do
    rock |> List.keysort(1, :desc) |> hd() |> elem(1)
  end
end
