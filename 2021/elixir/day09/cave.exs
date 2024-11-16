defmodule Cave do
  def find_basins(heightmap) do
    points =
      heightmap
      |> Map.keys()
      |> Enum.reject(&(Map.get(heightmap, &1) == 9))

    find_basins(points, heightmap, [])
  end

  defp find_basins([], _heightmap, basins), do: basins

  defp find_basins([current_point | points], heightmap, basins) do
    if processed_point?(current_point, basins) do
      find_basins(points, heightmap, basins)
    else
      new_basin = find_basin(current_point, heightmap)
      find_basins(points, heightmap, [new_basin | basins])
    end
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

  defp processed_point?(point, basins) do
    Enum.any?(basins, &MapSet.member?(&1, point))
  end
end
