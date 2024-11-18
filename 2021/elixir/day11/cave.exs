defmodule Cave do
  def execute_step(octopuses) do
    octopuses
    |> increase_energy_level(Map.keys(octopuses))
    |> execute_flashes()
  end

  defp increase_energy_level(octopuses, []), do: octopuses

  defp increase_energy_level(octopuses, [pos | remaining]) do
    increase_energy_level(
      Map.put(octopuses, pos, octopuses[pos] + 1),
      remaining
    )
  end

  defp execute_flashes(octopuses) do
    execute_flashes(octopuses, points_to_flash(octopuses, []), [], 0)
  end

  defp execute_flashes(octopuses, [], flashed_points, executed_flashes) do
    {
      Enum.reduce(flashed_points, octopuses, fn point, acc ->
        Map.put(acc, point, 0)
      end),
      executed_flashes
    }
  end

  defp execute_flashes(octopuses, [point | remaining], flashed_points, executed_flashes) do
    updated = execute_flash(point, octopuses)
    updated_to_flash = (remaining ++ points_to_flash(updated, flashed_points)) |> Enum.uniq()

    execute_flashes(updated, updated_to_flash, [point | flashed_points], executed_flashes + 1)
  end

  defp points_to_flash(octopuses, flashed_points),
    do:
      Enum.filter(Map.keys(octopuses), &(octopuses[&1] > 9))
      |> Enum.reject(&(&1 in flashed_points))
      |> Enum.uniq()

  defp execute_flash(point, octopuses) do
    neighborhood = neighbors(point, octopuses)

    octopuses
    |> increase_energy_level(neighborhood)
    |> Map.put(point, 0)
  end

  defp neighbors({x, y}, grid) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1},
      {x - 1, y - 1},
      {x + 1, y + 1},
      {x - 1, y + 1},
      {x + 1, y - 1}
    ]
    |> Enum.filter(&(&1 in Map.keys(grid)))
  end
end
