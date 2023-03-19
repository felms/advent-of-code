defmodule Cave do
  def find_basins(heightmap) do
    heightmap
    |> Map.keys()
    |> Enum.reject(&(Map.get(heightmap, &1) == 9))
    |> Enum.map(&find_basin(&1, heightmap))
    |> Enum.uniq()
  end

  defp find_basin(point, heightmap) do
    find_basin(heightmap, [point], [])
  end

  defp find_basin(_heightmap, [], explored), do: explored |> MapSet.new()

  defp find_basin(heightmap, [v | remaining_points], explored) do
    neighbors =
      valid_neighbors(v, heightmap)
      |> Enum.reject(&(&1 in explored))

    find_basin(heightmap, remaining_points ++ neighbors, [v | explored])
  end

  defp valid_neighbors({x, y}, heightmap) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.filter(&Map.has_key?(heightmap, &1))
    |> Enum.reject(&(Map.get(heightmap, &1) == 9))
  end
end
