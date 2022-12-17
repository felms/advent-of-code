defmodule Cave do

  # - Libera um grão de areia e o move até que 
  # o mesmo não tenha mais vizinhos possíveis
  def drop_sand(grid, grain_position) do

    neighbor = get_neighbor(grain_position, grid)
    if neighbor === :none do
      {grid, grain_position}
    else
      updated_grid = Map.put(grid, grain_position, ".") |> Map.put(neighbor, "o")
      drop_sand(updated_grid, neighbor) 
    end

  end

  def drop_sand(grid) do

    grain_position = {500, 0}
    neighbor = get_neighbor(grain_position, grid)

    if neighbor === :none do
      {grid, grain_position}
    else
      updated_grid = Map.put(grid, grain_position, ".") |> Map.put(neighbor, "o")
      drop_sand(updated_grid, neighbor) 
    end

  end

  # - Encontra o próximo vizinho possível de um ponto
  def get_neighbor({x, y}, grid) do
    cond do
      is_not_blocked?({x, y + 1}, grid) -> {x, y + 1}
      is_not_blocked?({x - 1, y + 1}, grid) -> {x - 1, y + 1}
      is_not_blocked?({x + 1, y + 1}, grid) -> {x + 1, y + 1}
      true -> :none
    end
  end

  # - Testa se um ponto já está bloqueado
  def is_not_blocked?(point, grid) do
    Map.get(grid, point) === "."
  end
end
