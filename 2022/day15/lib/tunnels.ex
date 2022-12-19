defmodule Tunnels do
  def calc_coverage(grid, row) do
    relevant_readings =
      Enum.filter(grid, fn reading ->
        sensor = reading.sensor
        x = sensor |> elem(0)
        Utils.manhattan_distance({x, row}, sensor) <= reading.distance
      end)

    number_of_beacons =
      relevant_readings
      |> Enum.reduce(MapSet.new(), fn reading, acc ->
        {_, y} = reading.beacon
        if y === row do
          MapSet.union(acc, MapSet.new([reading.beacon]))
        else
          acc
        end
      end)
      |> MapSet.to_list()
      |> length()

    covered_points =
    relevant_readings
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
    |> MapSet.to_list()
    |> length()

    covered_points - number_of_beacons

  end

  def calc_point_coverage(grid, []), do: grid

  def calc_point_coverage(grid, readings) do
    [current_reading | remaining_readings] = readings

    max_distance = current_reading.distance
    sensor = current_reading.sensor
    beacon = current_reading.beacon

    covered =
      Enum.reduce(grid, MapSet.new(), fn point, acc ->
        curr_distance = Utils.manhattan_distance(point, sensor)

        cond do
          curr_distance <= max_distance and point != beacon -> MapSet.put(acc, point)
          true -> acc
        end
      end)

    remaining_points =
      Enum.filter(grid, fn point ->
        not MapSet.member?(covered, point)
      end)

    calc_point_coverage(remaining_points, remaining_readings)
  end

  def create_row(readings, row) do
    {min_x, max_x} =
      Enum.reduce(readings, {100_000_000, -100_000_000}, fn reading, acc ->
        {curr_min_x, curr_max_x} = acc
        beacon_x = reading.beacon |> elem(0)
        sensor_x = reading.sensor |> elem(0)

        {
          Enum.min([beacon_x, sensor_x, curr_min_x]),
          Enum.max([beacon_x, sensor_x, curr_max_x])
        }
      end)

    for x <- min_x..max_x, do: {x, row}
  end

  def create_grid(readings) do
    {min_x, max_x, min_y, max_y} =
      Enum.reduce(readings, {100_000_000, -100_000_000, 100_000_000, -100_000_000}, fn reading,
                                                                                       acc ->
        {curr_min_x, curr_max_x, curr_min_y, curr_max_y} = acc
        beacon_x = reading.beacon |> elem(0)
        beacon_y = reading.beacon |> elem(1)
        sensor_x = reading.sensor |> elem(0)
        sensor_y = reading.sensor |> elem(1)

        {
          Enum.min([beacon_x, sensor_x, curr_min_x]),
          Enum.max([beacon_x, sensor_x, curr_max_x]),
          Enum.min([beacon_y, sensor_y, curr_min_y]),
          Enum.max([beacon_y, sensor_y, curr_max_y])
        }
      end)

    for x <- min_x..max_x, y <- min_y..max_y, do: {x, y}
  end
end
