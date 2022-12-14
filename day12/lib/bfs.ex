defmodule BFS do

  def bfs(start_position, end_position, graph) do

    find_path(end_position, graph, [start_position], 0, [], [start_position])

  end

  defp find_path( _, _, [], _, paths, _), do: paths 

  defp find_path(end_position, graph, queue, current_path, paths, explored) do 

    {v, new_queue} = List.pop_at(queue, 0)

    if v === end_position do
      [current_path | paths]
    else

      neighbors = find_neighbors(v, graph)

      {updated_queue, updated_explored} = Enum.reduce(neighbors, {new_queue, explored}, fn neighbor, acc -> 
        {i_queue, i_explored} = acc

        cond do 
          Enum.member?(i_explored, neighbor) -> acc
          true -> 
            acc_explored = [neighbor | i_explored]
            acc_queue = List.insert_at(i_queue, -1, neighbor)
            {acc_queue, acc_explored}
        end

      end)

      find_path(end_position, graph, updated_queue, current_path + 1, paths, updated_explored)

    end

  end 

  # - Encontra os todos os vizinhos permitidos de um ponto
  defp find_neighbors(point, matrix) do

    max_x = Enum.map(matrix, fn {{x, _}, _} -> x end) |> Enum.max
    max_y = Enum.map(matrix, fn {{_, y}, _} -> y end) |> Enum.max
    point_value = Map.get(matrix, point)

    find_all_neighbors(point, max_x, max_y)
    |> Enum.filter(fn neighbor ->

      neighbor_value = Map.get(matrix, neighbor)

      neighbor_value - point_value <= 1

    end)

  end

  # - Encontra todos os vizinhos de um ponto
  defp find_all_neighbors({x, y}, max_x, max_y) do 
    [{x, y + 1}, {x, y - 1}, {x - 1, y}, {x + 1, y}] 
    |> Enum.filter(fn {px, py} -> 
      px >= 0 and py >= 0 and px <= max_x and py <= max_y
    end)
  end

end
