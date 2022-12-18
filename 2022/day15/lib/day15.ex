defmodule Day15 do
  @moduledoc """
  Dia 15 do Advent of Code de 2022
  """

  # - Parse do input
  def parse_input(input_file) do
    File.read!(input_file)
    |> String.replace("\r", "") # Para evitar problemas no Windows
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_reading/1)
  end

  # - Parse de uma linha do input em um mapa com 
  # o beacon, o sensor e a distancia entre eles
  def parse_reading(reading) do
    [sensor_string, beacon_string] = 
      reading |> String.split(":", trim: true)

    replace_function = 
      fn entry -> String.replace(entry, ~r/.*=/, "") |> String.to_integer() end

    parse_function = 
      fn entry -> entry  
      |> String.split(",", trim: true)
      |> Enum.map(replace_function)
      |> List.to_tuple()
      end

    sensor = parse_function.(sensor_string)
    beacon = parse_function.(beacon_string)

    %{
      :sensor => sensor,
      :beacon => beacon,
      :distance => manhattan_distance(sensor, beacon)
    }
  end

  # - Distancia entre dois pontos
  defp manhattan_distance(point_a, point_b) do
    {x_1, y_1} = point_a
    {x_2, y_2} = point_b

    abs(x_1 - x_2) + abs(y_1 - y_2)
  end

end
