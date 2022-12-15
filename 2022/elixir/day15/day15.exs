defmodule Day15 do
  @moduledoc """
  Dia 15 do Advent of Code de 2022
  """
  
  Code.require_file("Utils.ex")
  Code.require_file("tunnels.ex")

  # Roda o problema no modo correto (teste ou real)
  def run(mode) do
    case mode do
      :sample -> run_sample()
      :real -> run_real_input()
    end
  end

  defp run_real_input do
    input = parse_input("input.txt")

    {time, result} = :timer.tc(&part_01/2, [input, 2_000_000])

    IO.puts(
      "==Part 01== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part_02/2, [input, 4_000_000])

    IO.puts(
      "==Part 02== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  defp run_sample do
    input = parse_input("sample_input.txt")

    {time, result} = :timer.tc(&part_01/2, [input, 10])

    IO.puts(
      "==Part 01== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part_02/2, [input, 20])

    IO.puts(
      "==Part 02== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  # ======= Problema 01 - Contar o número de posições
  # na linha informada onde um beacon não pode existir
  defp part_01(input, row) do
    readings = Tunnels.relevant_readings(input, row)

    beacons = Tunnels.number_of_beacons(readings, row)

    covered_points =
      Tunnels.calc_coverage(readings, row)
      |> MapSet.to_list()
      |> length()

    covered_points - beacons
  end

  # ======= Problema 02 - Descobre a 'tuning frequency'
  # do único ponto no grid não coberto por nenhum sensor
  defp part_02(input, max_row_value) do
    {x, y} =
      Enum.reduce_while(input, [], fn reading, _acc ->
        {found, point} =
          Tunnels.get_points_outside_border(reading, max_row_value)
          |> Enum.reduce_while({}, fn point, _acc ->
            uncovered = Tunnels.uncovered_point?(point, input)

            if uncovered do
              {:halt, {true, point}}
            else
              {:cont, {false, point}}
            end
          end)

        if found do
          {:halt, point}
        else
          {:cont, :not_found}
        end
      end)

    x * 4_000_000 + y
  end

  # - Parse do input
  defp parse_input(input_file) do
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

# --- Run
System.argv()
|> hd
|> String.to_atom
|> Day15.run()