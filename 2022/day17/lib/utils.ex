defmodule Utils do
  # - Pega o ponto mais alto do grid
  def grid_highest_row(grid) do
    grid
    |> MapSet.to_list()
    |> List.keysort(0, :desc)
    |> hd()
    |> elem(0)
  end

  def state_hash(grid, rock, jets) do
    rock_string = Enum.map(rock, fn {r, c} -> "{#{r},#{c}}" end)

    get_grid_cache(grid) <>
      Enum.join(rock_string) <>
      Enum.join(jets)
  end

  def get_grid_cache(grid) do
    grid
    |> MapSet.to_list()
    |> highest_points()
    |> normalize_points(grid)
    |> Enum.map(fn {r, c} -> "{#{r},#{c}}" end)
    |> Enum.join()
  end

  defp normalize_points(points, grid) do
    highest_row = grid_highest_row(grid)

    points
    |> Enum.map(fn {row, column} -> {row - highest_row, column} end)
  end

  defp highest_points(grid) do
    Enum.reduce(0..6, [], fn index, acc ->
      [highest_point_of_column(grid, index) | acc]
    end)
  end

  defp highest_point_of_column(grid, column) do
    grid
    |> Enum.filter(fn {_row, col} -> col === column end)
    |> Enum.sort(fn {row0, _col0}, {row1, _col1} -> row0 >= row1 end)
    |> hd()
  end
end
