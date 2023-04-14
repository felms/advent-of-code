defmodule Cave do
  # - Utiliza BFS para gerar todos os 
  # caminhos possíveis apartir do inicio.
  def list_paths(graph) do
    list_paths(graph, ["start"], ["start"], ["start"], [])
  end

  defp list_paths(_graph, [], _current_path, _explored, paths), do: paths

  defp list_paths(graph, [current_node | queue], current_path, explored, paths) do
    if current_node == "end" do
      list_paths(graph, queue, current_path, explored, [current_path | paths])
    else
      Enum.reduce(neighbors(current_node, graph, explored), paths, fn w, acc ->
        new_explored = if small_cave?(w), do: [w | explored], else: explored
        list_paths(graph, queue ++ [w], [w | current_path], new_explored, acc)
      end)
    end
  end

  # - Encontra os possíveis vizinhos de um ponto
  defp neighbors(cave, graph, visited) do
    Map.get(graph, cave)
    |> Enum.reject(&(&1 in visited))
  end

  # - Utiliza BFS para gerar todos os 
  # caminhos possíveis apartir do inicio.
  # Com a regra sobre as cavernas pequenas 
  # específica para o problema 02.
  def list_paths_2(graph) do
    list_paths_2(graph, ["start"], ["start"], ["start"], [])
  end

  defp list_paths_2(_graph, [], _current_path, _explored, paths), do: paths

  defp list_paths_2(graph, [current_node | queue], current_path, explored, paths) do
    if current_node == "end" do
      list_paths_2(graph, queue, current_path, explored, [current_path | paths])
    else
      Enum.reduce(neighbors_2(current_node, graph, explored), paths, fn w, acc ->
        new_explored = if small_cave?(w), do: [w | explored], else: explored
        list_paths_2(graph, queue ++ [w], [w | current_path], new_explored, acc)
      end)
    end
  end

  # - Encontra os possíveis vizinhos de um ponto
  # utilizando a regra específica para a 
  # parte 02 do problema
  defp neighbors_2(cave, graph, visited) do
    repeated_small_cave? = visited |> Enum.uniq() != visited

    if repeated_small_cave? do
      Map.get(graph, cave)
      |> Enum.reject(&(&1 in visited))
    else
      Map.get(graph, cave)
      |> Enum.reject(&(&1 == "start"))
    end
  end

  # - Testa se é uma das "cavernas pequenas"
  defp small_cave?(cave), do: cave =~ ~r/[a-z]+/
end
