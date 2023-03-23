defmodule Tunnels do
  @big_distance 1_000_000

  # - Roda o DFS para cada uma das válvulas
  # para calcular a distância entre todas
  # tomando cada uma como ponto de partida
  def calc_distances(graph) do
    graph
    |> Map.keys()
    |> Enum.map(&{&1, dfs(graph, &1, %{}, [&1], 0)})
    |> Enum.into(%{})
  end

  # - Usa o algoritmo DFS para calcular as distancias
  # de um vértice (válvula) para todos os outros no
  # no grafo (conjunto de tuneis)
  defp dfs(graph, source, dists, discovered, distance) do
    current_discovered = [source | discovered]
    min_dist_to_source = Map.get(dists, source, @big_distance) |> min(distance)
    current_dists = Map.put(dists, source, min_dist_to_source)

    neighbors =
      graph[source][:tunnels]
      |> Enum.reject(&(&1 in discovered))

    Enum.reduce(neighbors, current_dists, fn neighbor, acc ->
      dfs(graph, neighbor, acc, current_discovered, distance + 1)
    end)
  end
end
