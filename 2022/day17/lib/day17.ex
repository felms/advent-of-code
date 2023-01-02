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

    #{_new_rock, new_grid, _new_move, new_jets} =
    #  drop_rock(rocks.horizontal, initial_grid, jets)

    #{_, res, _, _} =
    #  drop_rock(rocks.cross, new_grid, new_jets)

    #res

    rocks_list = [rocks.horizontal, rocks.cross, rocks.corner, rocks.vertical, rocks.square]

    {_, res_grid, _} =
    Enum.reduce(0..2023, {rocks_list, initial_grid, jets}, fn _, acc ->
      {curr_rocks_list, curr_grid, curr_jets} = acc

      {curr_rock, remaining_rocks} = List.pop_at(curr_rocks_list, 0)
      new_rocks_list = List.insert_at(remaining_rocks, -1, curr_rock)

      {_, new_grid, _, new_jets} = drop_rock(curr_rock, curr_grid, curr_jets)

      {new_rocks_list, new_grid, new_jets}

    end)

    grid_highest_row(res_grid)

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
    move = :lateral

    Enum.reduce_while(0..100, {rock_pos, grid, move, jets}, fn _, acc ->
      {curr_rock, curr_grid, curr_move, curr_jets} = acc

      {move_result, new_move, new_jets} = move_rock(curr_rock, curr_move, curr_jets, grid)
      {status, new_rock} = move_result

      if status === :stopped and curr_move === :vertical do
        new_grid = MapSet.union(grid, MapSet.new(curr_rock))
        {:halt, {curr_rock, new_grid, curr_move, curr_jets}}
      else
        {:cont, {new_rock, curr_grid, new_move, new_jets}}
      end

    end)

  end

  def move_rock(rock, move, jets, grid) do
    if move === :vertical do
      move_result = vertical_move(rock, grid)
      new_move = :lateral
      {move_result, new_move, jets}
    else
      {direction, remaining_jets} = List.pop_at(jets, 0)
      new_jets = List.insert_at(remaining_jets, -1, direction)
      new_move = :vertical
      move_result = lateral_move(rock, direction, grid)
      {move_result, new_move, new_jets}
    end
  end

  def vertical_move(rock, grid) do

      new_rock = rock |> Enum.map(fn {row, col} -> {row - 1, col} end)
      cant_move =
        Enum.any?(new_rock, fn point -> MapSet.member?(grid, point) end)

      if cant_move do
        {:stopped, rock}
      else
        {:moved, new_rock}
      end

  end

  def lateral_move(rock, direction, grid) do

    cond do
      direction === "<" ->
        left_move(rock, grid)
      direction === ">" ->
        right_move(rock, grid)
    end

  end

  def left_move(rock, grid) do
    new_rock = rock |> Enum.map(fn {row, column} -> {row, column - 1} end)

    cant_move = Enum.any?(new_rock, fn point ->
      MapSet.member?(grid, point) or point |> elem(1) < 0
    end)

    if cant_move do
      {:stopped, rock}
    else
      {:moved, new_rock}
    end
  end

  def right_move(rock, grid) do
    new_rock = rock |> Enum.map(fn {row, column} -> {row, column + 1} end)

    cant_move = Enum.any?(new_rock, fn point ->
      MapSet.member?(grid, point) or point |> elem(1) > 6
    end)

    if cant_move do
      {:stopped, rock}
    else
      {:moved, new_rock}
    end
  end

end
