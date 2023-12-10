defmodule Day10 do
  @moduledoc """
  Dia 10 do Advent of Code 2023
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

  def part_01(grid) do
    grid
    |> Enum.filter(fn {_, v} -> v == "S" end)
    |> hd()
    |> then(&run_through_loop(&1, &1, &1, 0, grid))
    |> then(&div(&1, 2))
  end

  def run_through_loop(starting_point, _last_point, starting_point, steps, _grid) when steps > 2,
    do: steps

  def run_through_loop(current_point, last_point, starting_point, steps, grid) do
    next_point =
      get_neighbors(grid, current_point)
      |> Enum.reject(&(&1 == last_point))
      |> hd()

    {{r, c}, _v} = current_point

    run_through_loop(
      {next_point, grid[next_point]},
      {r, c},
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
end

# --- Run
System.argv
|> hd
|> Day10.run