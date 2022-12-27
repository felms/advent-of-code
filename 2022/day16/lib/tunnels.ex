defmodule Tunnels do

  # - Roda o DFS para cada uma das válvulas
  # para calcular a distância entre todas
  # tomando cada uma como ponto de partida
  def calc_distances(graph) do
    Enum.reduce(graph, %{}, fn {key, _}, acc ->
      Map.put(acc, key, dfs(graph, key, [], %{}, 0))
    end)
  end

  # - Usa o algoritmo DFS para calcular as distancias
  # de um vértice (válvula) para todos os outros no
  # no grafo (conjunto de tuneis)
  def dfs(graph, source, discovered, res, dist) do
    current_discovered = [source | discovered]
    current_res = Map.put(res, source, dist)
    neighbors = graph[source][:tunnels]
    |> Enum.reject(fn item -> Enum.member?(current_discovered, item) end)
    |> Enum.reject(fn item -> Map.has_key?(current_res, item) end)

    Enum.reduce(neighbors, current_res, fn neighbor, acc ->
      dfs(graph, neighbor, current_discovered, acc, dist + 1)
    end)

  end

  def get_neighbors(tunnel, graph) do
    list = Map.get(graph, tunnel) |> Map.get(:tunnels)

    Enum.reduce(list, [], fn t, acc ->
      flow = Map.get(graph, t) |> Map.get(:flow_rate)
      [{t, flow}] ++ acc
    end)
  end
end
