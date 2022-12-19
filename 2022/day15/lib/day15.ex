defmodule Day15 do
  @moduledoc """
  Dia 15 do Advent of Code de 2022
  """

  def run(input_file, row) do
    input = parse_input(input_file)

    {time, result} = :timer.tc(&part_01/2, [input, row])

    IO.puts(
      "==Part 01== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  # ======= Problema 01 - Contar o número de posições
  # na linha informada onde um beacon não pode existir
  def part_01(input, row) do
    readings = Tunnels.relevant_readings(input, row)

    beacons = Tunnels.number_of_beacons(readings, row)

    covered_points =
      Tunnels.calc_coverage(readings, row)
      |> MapSet.to_list()
      |> length()

    covered_points - beacons
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
