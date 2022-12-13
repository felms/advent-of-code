defmodule BFS do

  def find_path(start_position, end_position, graph) do

    explored = [start_position]

    {paths, _} = recursive_find_path(start_position, end_position, explored, 0, [], graph)

    paths

  end

  def recursive_find_path(_, _, explored, _, paths, graph)
                            when explored |> length === graph |> length,  do: {paths, explored}

  def recursive_find_path(start_position, end_position, explored, current_path, paths, graph) do

    if start_position === end_position do
      {[current_path | paths], explored}
    else

      neighbors = find_neighbors(start_position, graph)
      |> Enum.filter(fn neighbor -> not Enum.member?(explored, neighbor) end)

      cond do
        Enum.empty?(neighbors) -> {paths, explored}
        true ->
          Enum.reduce(neighbors, {paths, explored}, fn neighbor, acc ->
            {p, e} = acc
            new_explored = [neighbor | e]

            {new_paths, _} = recursive_find_path(neighbor, end_position, new_explored, current_path + 1, p, graph)
            {new_paths, e}
          end)

      end

    end
  end

   # - Encontra os todos os vizinhos permitidos de um ponto
   def find_neighbors(point, matrix) do

    max_x = Enum.map(matrix, fn {{x, _}, _} -> x end) |> Enum.max
    max_y = Enum.map(matrix, fn {{_, y}, _} -> y end) |> Enum.max
    point_value = Map.get(matrix, point)

    find_all_neighbors(point, max_x, max_y)
    |> Enum.filter(fn neighbor ->

      neighbor_value = Map.get(matrix, neighbor)

      point_value - neighbor_value >= -1

    end)

  end

  # - Encontra todos os vizinhos nas 4 pontas
  def find_all_neighbors({x, y}, _, _) when x === 0 and y === 0, do: [{0, 1}, {1, 0}]
  def find_all_neighbors({x, y}, max_x, max_y) when x === max_x and y === max_y, do: [{max_x, max_y - 1}, {max_x - 1, max_y}]
  def find_all_neighbors({x, y}, max_x, _) when x === max_x and y === 0, do: [{max_x, 1}, {max_x - 1, 0}]
  def find_all_neighbors({x, y}, _, max_y) when x === 0 and y === max_y, do: [{0, max_y - 1}, {1, max_y}]

  # - Encontra todos os vizinhos nas linhas e colunas das bordas
  def find_all_neighbors({x, y}, _, _) when x === 0, do: [{x, y - 1}, {x, y + 1}, {x + 1, y}]
  def find_all_neighbors({x, y}, _, _) when y === 0, do: [{x - 1, y}, {x + 1, y}, {x, y + 1}]
  def find_all_neighbors({x, y}, max_x, _) when x === max_x, do: [{x, y - 1}, {x, y + 1}, {x - 1, y}]
  def find_all_neighbors({x, y}, _, max_y) when y === max_y, do: [{x - 1, y}, {x + 1, y}, {x, y - 1}]

  # - Encontra todos os vizinhos no centro da matriz
  def find_all_neighbors({x, y}, _, _), do: [{x, y + 1}, {x, y - 1}, {x - 1, y}, {x + 1, y}]

end
