defmodule Day15 do
  @moduledoc """
  Dia 15 do Advent of Code de 2022
  """

  def run(input_file, row) do
    IO.puts("\nParsing input...")
    input = parse_input(input_file)

    IO.puts("")
    # IO.puts("Part 01: #{part_01(input, row)}")
    part_01(input, row)
  end

  def part_01(input, row) do
    IO.puts("Creating grid...")
    grid = Tunnels.create_row(input, row)

    IO.puts("Calculating coverage...")

    # not_covered_points =
    #  Tunnels.calc_point_coverage(grid, input)
    #  |> length()

    # grid_size = grid |> length()

    # grid_size - not_covered_points

    Tunnels.calc_coverage(input, row)
  end

  # - Parse do input
  def parse_input(input_file) do
    File.read!(input_file)
    # Para evitar problemas no Windows
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_reading/1)
  end

  # - Parse de uma linha do input em um mapa com
  # o beacon, o sensor e a distancia entre eles
  def parse_reading(reading) do
    [sensor_string, beacon_string] = reading |> String.split(":", trim: true)

    replace_function = fn entry -> String.replace(entry, ~r/.*=/, "") |> String.to_integer() end

    parse_function = fn entry ->
      entry
      |> String.split(",", trim: true)
      |> Enum.map(replace_function)
      |> List.to_tuple()
    end

    sensor = parse_function.(sensor_string)
    beacon = parse_function.(beacon_string)

    %{
      :sensor => sensor,
      :beacon => beacon,
      :distance => Utils.manhattan_distance(sensor, beacon)
    }
  end
end
