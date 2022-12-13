defmodule Graph do


  def findAllPaths(start_node, end_node, heightmap) do

    visited = [start_node]
    current_path = 0

    all_paths = []

    {all_paths, _} = findAllPathsUtil(start_node, end_node, heightmap, visited, current_path, all_paths)

    all_paths

  end


  def findAllPathsUtil(start_node, end_node, _, _, current_path, all_paths) when start_node === end_node do

    {[current_path | all_paths], current_path}

  end

  def findAllPathsUtil(start_node, end_node, heightmap, visited, current_path, all_paths) do

    updated_visited = [start_node | visited]

    neighbors = find_neighbors(start_node, heightmap)

    {end_all_paths, end_curr} = Enum.reduce(neighbors, {all_paths, current_path}, fn neighbor, acc ->

      {red_all_paths, red_curr_path} = acc

      if not Enum.member?(updated_visited, neighbor) do
        new_curr_path =  red_curr_path + 1
        {new_all_paths, _} = findAllPathsUtil(neighbor, end_node, heightmap, updated_visited, new_curr_path, red_all_paths)
        {new_all_paths, red_curr_path}
      else
        acc
      end

    end)


    {end_all_paths, end_curr}

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
  def find_all_neighbors({x, y}, max_x, _) when x === max_x and y === 0, do: [{max_x, 1}, {max_x - 1, 0}]
  def find_all_neighbors({x, y}, _, max_y) when x === 0 and y === max_y, do: [{0, max_y - 1}, {1, max_y}]
  def find_all_neighbors({x, y}, max_x, max_y) when x === max_x and y === max_y, do: [{max_x, max_y - 1}, {max_x - 1, max_y}]

  # - Encontra todos os vizinhos nas linhas e colunas das bordas
  def find_all_neighbors({x, y}, _, _) when x === 0, do: [{x, y - 1}, {x, y + 1}, {x + 1, y}]
  def find_all_neighbors({x, y}, _, _) when y === 0, do: [{x - 1, y}, {x + 1, y}, {x, y + 1}]
  def find_all_neighbors({x, y}, max_x, _) when x === max_x, do: [{x, y - 1}, {x, y + 1}, {x - 1, y}]
  def find_all_neighbors({x, y}, _, max_y) when y === max_y, do: [{x - 1, y}, {x + 1, y}, {x, y - 1}]

  # - Encontra todos os vizinhos no centro da matriz
  def find_all_neighbors({x, y}, _, _), do: [{x, y + 1}, {x, y - 1}, {x - 1, y}, {x + 1, y}]

end
