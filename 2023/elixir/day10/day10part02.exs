defmodule Day10Part02 do
  @moduledoc """
  Dia 10 do Advent of Code 2023
  """

  def run(input_file) do
    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> parse_input()

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "\n==Part 02== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  def parse_input(input_string) do
    points =
      input_string
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

  def part_02(grid) do
    grid
    |> Enum.filter(fn {_, v} -> v == "S" end)
    |> hd()
    |> then(&run_through_loop(&1, &1, [], &1, 0, grid))
    |> find_points_inside(grid)
    |> Enum.count()
  end

  def find_points_inside(loop_points, grid) do
    {pos_start, _} =
      grid
      |> Enum.filter(fn {_, v} -> v == "S" end)
      |> hd()

    new_grid =
      grid
      |> Map.put(pos_start, replace_start({pos_start, "S"}, grid))
      |> Enum.map(fn {{r, c}, v} ->
        if {r, c} in loop_points, do: {{r, c}, v}, else: {{r, c}, "."}
      end)
      |> Map.new()

    max_row = grid |> Map.keys() |> Enum.map(fn {r, _c} -> r end) |> Enum.max()
    max_col = grid |> Map.keys() |> Enum.map(fn {_r, c} -> c end) |> Enum.max()

    0..max_row
    |> Enum.reduce([], fn row_number, acc ->
      [mark_points_in_row(new_grid, loop_points, row_number, 0, max_col, false, []) | acc]
    end)
    |> List.flatten()
    |> Enum.filter(fn {_pt, inside?} -> inside? end)
    |> Enum.reject(fn {pt, _} -> pt in loop_points end)
  end

  def mark_points_in_row(_grid, _loop_points, _row, current_col, max_col, _inside?, res_row)
      when current_col > max_col,
      do: res_row

  def mark_points_in_row(grid, loop_points, row, current_col, max_col, inside?, res_row) do
    point = grid[{row, current_col}]

    new_inside? = if point in ["|", "F", "7"], do: not inside?, else: inside?

    new_res_row = [{{row, current_col}, new_inside?} | res_row]
    mark_points_in_row(grid, loop_points, row, current_col + 1, max_col, new_inside?, new_res_row)
  end

  def run_through_loop(starting_point, _last_point, visited_points, starting_point, steps, _grid)
      when steps > 2,
      do: visited_points

  def run_through_loop(current_point, last_point, visited_points, starting_point, steps, grid) do
    next_point =
      get_neighbors(grid, current_point)
      |> Enum.reject(&(&1 == last_point))
      |> hd()

    {{r, c}, _v} = current_point

    run_through_loop(
      {next_point, grid[next_point]},
      {r, c},
      [{r, c} | visited_points],
      starting_point,
      steps + 1,
      grid
    )
  end

  def get_neighbors(_grid, {{r, c}, "|"}), do: [{r - 1, c}, {r + 1, c}]
  def get_neighbors(_grid, {{r, c}, "-"}), do: [{r, c - 1}, {r, c + 1}]
  def get_neighbors(_grid, {{r, c}, "L"}), do: [{r - 1, c}, {r, c + 1}]
  def get_neighbors(_grid, {{r, c}, "J"}), do: [{r - 1, c}, {r, c - 1}]
  def get_neighbors(_grid, {{r, c}, "7"}), do: [{r + 1, c}, {r, c - 1}]
  def get_neighbors(_grid, {{r, c}, "F"}), do: [{r + 1, c}, {r, c + 1}]
  def get_neighbors(_grid, {_, "."}), do: []

  def get_neighbors(grid, {{r, c}, "S"}) do
    cond do
      Map.get(grid, {r, c + 1}) in ["-", "J", "7"] -> [{r, c + 1}]
      Map.get(grid, {r + 1, c}) in ["|", "L", "J"] -> [{r + 1, c}]
      Map.get(grid, {r, c - 1}) in ["-", "L", "F"] -> [{r, c - 1}]
      Map.get(grid, {r - 1, c}) in ["|", "7", "F"] -> [{r - 1, c}]
    end
  end

  def replace_start({{r, c}, "S"}, grid) do
    right = Map.get(grid, {r, c + 1})
    down = Map.get(grid, {r + 1, c})
    left = Map.get(grid, {r, c - 1})
    up = Map.get(grid, {r - 1, c})

    cond do
      right in ["-", "J", "7"] and down in ["|", "J", "L"] -> "F"
      right in ["-", "J", "7"] and up in ["|", "F", "7"] -> "L"
      left in ["-", "F", "L"] and up in ["|", "F", "7"] -> "J"
      left in ["-", "F", "L"] and down in ["|", "J", "L"] -> "7"
      up in ["|", "F", "7"] and down in ["|", "J", "L"] -> "|"
      left in ["-", "F", "L"] and right in ["-", "J", "7"] -> "-"
    end
  end
end

# ---- Run
System.argv
|> hd
|> Day10Part02.run