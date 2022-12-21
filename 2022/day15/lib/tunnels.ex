defmodule Tunnels do
  # - Filtra as leituras do input para
  # deixar apenas as que possuem sensores que possam cobrir a linha
  # fornecida
  def relevant_readings(readings, row) do
    Enum.filter(readings, fn reading ->
      sensor = reading.sensor
      x = sensor |> elem(0)
      Utils.manhattan_distance({x, row}, sensor) <= reading.distance
    end)
  end

  # - Calcula o número de beacons presentes em uma linha
  def number_of_beacons(readings, row) do
    Enum.reduce(readings, MapSet.new(), fn reading, acc ->
      {_, y} = reading.beacon

      if y === row do
        MapSet.union(acc, MapSet.new([reading.beacon]))
      else
        acc
      end
    end)
    |> MapSet.to_list()
    |> length()
  end

  # - Calcula os pontos uma linha cobertos por sensores
  def calc_coverage(readings, row) do
    readings
    |> Enum.map(fn reading ->
      Utils.points_in_range(reading.sensor, reading.distance)
      |> Enum.filter(fn {_, y} -> y === row end)
    end)
    |> Enum.reduce(MapSet.new(), fn points, acc ->
      number_of_points = points |> length()

      if number_of_points === 2 do
        [{x_0, _}, {x_1, _}] = points
        range = for x <- x_0..x_1, do: {x, row}
        MapSet.union(acc, MapSet.new(range))
      else
        MapSet.union(acc, MapSet.new(points))
      end
    end)
  end

  # - Gera os pontos fora da borda da área
  # coberta por um sensor, filtrando para
  # valor máximo permitido de linhas e colunas
  def get_points_outside_border(reading, max_row_value) do
    Utils.points_in_range(reading.sensor, reading.distance + 1)
    |> Enum.filter(fn {x, y} ->
      x >= 0 and x <= max_row_value and
        y >= 0 and y <= max_row_value
    end)
  end

  # - Testa se o ponto está coberto por algum sensor
  def uncovered_point?(point, readings) do
    Enum.reduce_while(readings, true, fn reading, _acc ->
      dist = Utils.manhattan_distance(point, reading.sensor)

      if dist <= reading.distance do
        {:halt, false}
      else
        {:cont, true}
      end
    end)
  end
end
