defmodule BFS02 do

  # - Faz o setup inicial das variáveis e chama o
  # metodo recursivo que executa o algoritmo
  # A execução é feita do ponto final para o
  # inicial e se retorna o primeiro 'a' encontrado
  # pois ele é o mais próximo do ponto final
  def bfs(_start_position, end_position, graph) do

    queue = [{end_position, 0}]
    visited = [end_position]

    find_path(graph, queue, visited)

  end

  # - Método recursivo que executa o BFS

  defp find_path(_, [], _), do: %{:dist => -1}


  defp find_path(graph, queue, visited) do

    {{node, dist}, new_queue} = List.pop_at(queue, 0)

    node_value = Map.get(graph, node)
    # Se enccontrou um ponto 'a' (valor === 0) retorna
    if node_value === 0 do
      %{:dist => dist}
    else
      neighbors = find_neighbors(node, graph)

      {res_queue, res_visited} = Enum.reduce(neighbors, {new_queue, visited}, fn neighbor, acc ->
        {i_queue, i_visited} = acc
        cond do
          not Enum.member?(i_visited, neighbor) ->
            acc_queue = List.insert_at(i_queue, -1, {neighbor, dist + 1})
            acc_visited = [neighbor | i_visited]
            {acc_queue, acc_visited}
          true -> acc
        end
      end)
      find_path(graph, res_queue, res_visited)
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

      # O valor é invertido pois a busca está sendo feita
      # do final para o começo
      neighbor_value - point_value >= -1

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
