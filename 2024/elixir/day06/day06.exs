defmodule Day06 do
  @moduledoc """
  Dia 06 do Advent of Code 2024
  """

  def run(input_file) do

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
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

  def part_01(input) do
    pos = initial_pos(input)

    exec_steps(pos, :up, input, MapSet.new([pos]), :ongoing)
    |> MapSet.size()
  end

  def part_02(input) do
    pos = initial_pos(input)

    exec_steps(pos, :up, input, MapSet.new([pos]), :ongoing)
    |> Enum.filter(&(Map.get(input, &1) == "."))
    |> Enum.filter(
      &(exec_steps_02(pos, :up, Map.put(input, &1, "#"), MapSet.new([{pos, :up}]), :ongoing) == :found_loop))
    |> length
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(&parse_line/1)
    |> Map.new()
  end

  def parse_line({row, row_number}) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(&{{row_number, elem(&1, 1)}, elem(&1, 0)})
  end

  def initial_pos(grid) do
    grid
    |> Map.to_list()
    |> Enum.filter(fn {_point, v} -> v == "^" end)
    |> hd
    |> elem(0)
  end

  def exec_steps(_, _, _, visited_positions, :finished), do: visited_positions

  def exec_steps(current_pos, direction, grid, visited_positions, :ongoing) do
    {next_pos, next_dir} = find_next_position(current_pos, direction, grid)

    if Map.get(grid, next_pos, :outside) == :outside do
      exec_steps(current_pos, direction, grid, visited_positions, :finished)
    else
      exec_steps(next_pos, next_dir, grid, MapSet.put(visited_positions, next_pos), :ongoing)
    end
  end

  def exec_steps_02(current_pos, direction, grid, visited_positions, :ongoing) do
    {next_pos, next_dir} = find_next_position(current_pos, direction, grid)

    cond do
      Map.get(grid, next_pos, :outside) == :outside -> :finished
      MapSet.member?(visited_positions, {next_pos, next_dir}) -> :found_loop
      true -> exec_steps_02(
          next_pos,
          next_dir,
          grid,
          MapSet.put(visited_positions, {next_pos, next_dir}),
          :ongoing
        )
    end
  end

  def find_next_position(current_position, current_direction, grid) do
    next_p = next_position(current_position, current_direction)

    if Map.get(grid, next_p) == "#" do
      find_next_position(current_position, turn_right(current_direction), grid)
    else
      {next_p, current_direction}
    end
  end

  def next_position({r, c}, :up), do: {r - 1, c}
  def next_position({r, c}, :left), do: {r, c - 1}
  def next_position({r, c}, :down), do: {r + 1, c}
  def next_position({r, c}, :right), do: {r, c + 1}

  def turn_right(:up), do: :right
  def turn_right(:right), do: :down
  def turn_right(:down), do: :left
  def turn_right(:left), do: :up
end

# ---- Run 
System.argv
|> hd
|> Day06.run