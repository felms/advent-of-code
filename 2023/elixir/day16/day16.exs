defmodule Day16 do
  @moduledoc """
  Dia 16 do Advent of Code 2023
  """
  
  Code.require_file("beam.ex")
  Code.require_file("state.ex")

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

  # - Problema 01
  def part_01(grid) do
    starting_point = Beam.new({0, 0}, :east)
    starting_state = State.new([starting_point])

    resulting_state = run_simulation(starting_state, grid)

    resulting_state.energized_tiles
    |> Enum.uniq()
    |> Enum.count()
  end

  # - Problema 02
  def part_02(grid) do

    get_edge_beams(grid)
    |> Enum.map(fn beam ->
      starting_state = State.new([beam])

      resulting_state = run_simulation(starting_state, grid)

      resulting_state.energized_tiles
      |> Enum.uniq()
      |> Enum.count()
    end)
    |> Enum.max()

  end

  # - Gera os feixes de luz vindo
  # dos quatro lados do grid.
  def get_edge_beams(grid) do
    max_r =
      grid
      |> Enum.map(fn {{r, _c}, _v} -> r end)
      |> Enum.max()

    max_c =
      grid
      |> Enum.map(fn {{_r, c}, _v} -> c end)
      |> Enum.max()

    upper_row =
      for c <- 0..max_c, do: Beam.new({0, c}, :south)

    bottom_row =
      for c <- 0..max_c, do: Beam.new({max_r, c}, :north)

    leftmost_column =
      for r <- 0..max_r, do: Beam.new({r, 0}, :east)

    rightmost_column =
      for r <- 0..max_r, do: Beam.new({r, max_c}, :west)

    upper_row ++ bottom_row ++ leftmost_column ++ rightmost_column
  end

  # - Roda a simulação
  def run_simulation(state, _grid) when state.execution_queue == [], do: state

  def run_simulation(state, grid) do
    [current_beam | remaining_queue] = state.execution_queue

    pos = current_beam.position
    processed_beams = MapSet.put(state.processed_beams, current_beam)

    cond do
      MapSet.member?(state.processed_beams, current_beam) ->
        run_simulation(
          State.new(remaining_queue, state.energized_tiles, state.processed_beams),
          grid
        )

      not Map.has_key?(grid, current_beam.position) ->
        run_simulation(
          State.new(remaining_queue, state.energized_tiles, processed_beams),
          grid
        )

      grid[pos] == "." ->
        run_simulation(
          State.new(move_beam(current_beam, remaining_queue), [pos | state.energized_tiles], processed_beams),
          grid
        )

      grid[pos] in ["/", "\\"] ->
        run_simulation(
          State.new(reflect_beam(current_beam, grid, remaining_queue), [pos | state.energized_tiles], processed_beams),
          grid
        )

      grid[pos] in ["|", "-"] ->
        run_simulation(
          State.new(pass_through_splitter(current_beam, grid, remaining_queue), [pos | state.energized_tiles], processed_beams),
          grid
        )
    end
  end

  # - Move um feixe de luz uma vez
  def move_beam(beam, execution_queue) do
    {r, c} = beam.position

    case beam.direction do
      :east -> [Beam.new({r, c + 1}, beam.direction) | execution_queue]
      :west -> [Beam.new({r, c - 1}, beam.direction) | execution_queue]
      :north -> [Beam.new({r - 1, c}, beam.direction) | execution_queue]
      :south -> [Beam.new({r + 1, c}, beam.direction) | execution_queue]
    end
  end

  # - Reflete um feixe de luz
  def reflect_beam(beam, grid, execution_queue) do
    {r, c} = beam.position
    mirror = grid[beam.position]

    cond do
      mirror == "/" and beam.direction == :east ->
        execution_queue ++ [Beam.new({r - 1, c}, :north)]

      mirror == "/" and beam.direction == :west ->
        execution_queue ++ [Beam.new({r + 1, c}, :south)]

      mirror == "/" and beam.direction == :north ->
        execution_queue ++ [Beam.new({r, c + 1}, :east)]

      mirror == "/" and beam.direction == :south ->
        execution_queue ++ [Beam.new({r, c - 1}, :west)]

      mirror == "\\" and beam.direction == :east ->
        execution_queue ++ [Beam.new({r + 1, c}, :south)]

      mirror == "\\" and beam.direction == :west ->
        execution_queue ++ [Beam.new({r - 1, c}, :north)]

      mirror == "\\" and beam.direction == :north ->
        execution_queue ++ [Beam.new({r, c - 1}, :west)]

      mirror == "\\" and beam.direction == :south ->
        execution_queue ++ [Beam.new({r, c + 1}, :east)]
    end
  end

  # - Passa um feixe de luz por um divisor
  def pass_through_splitter(beam, grid, execution_queue) do
    {r, c} = beam.position
    splitter = grid[beam.position]

    cond do
      splitter == "-" and beam.direction == :east ->
        [Beam.new({r, c + 1}, :east) | execution_queue]

      splitter == "-" and beam.direction == :west ->
        [Beam.new({r, c - 1}, :west) | execution_queue]

      splitter == "-" and beam.direction in [:north, :south] ->
        execution_queue ++ [Beam.new({r, c - 1}, :west), Beam.new({r, c + 1}, :east)]

      splitter == "|" and beam.direction == :north ->
        [Beam.new({r - 1, c}, :north) | execution_queue]

      splitter == "|" and beam.direction == :south ->
        [Beam.new({r + 1, c}, :south) | execution_queue]

      splitter == "|" and beam.direction in [:east, :west] ->
        execution_queue ++ [Beam.new({r - 1, c}, :north), Beam.new({r + 1, c}, :south)]
    end
  end
end

# ---- Run
System.argv
|> hd
|> Day16.run