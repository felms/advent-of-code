defmodule Tunnels do
  @big_distance 1_000_000

  def pressure_release(graph, time, valve, dists, open_valves) do
    neighbors = get_neighbors(valve, dists, graph)

    Enum.reduce(neighbors, 0, fn neighbor, max_value ->
      remtime = time - dists[valve][neighbor] - 1

      cond do
        Enum.member?(open_valves, neighbor) ->
          max_value

        remtime <= 0 ->
          max_value

        true ->
          max(
            max_value,
            pressure_release(graph, remtime, neighbor, dists, [neighbor | open_valves]) +
              graph[neighbor][:flow_rate] * remtime
          )
      end
    end)
  end

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

  # - Retorna um lista com todas as válvulas acessiveis
  # apartir da valvula indicada e cujas taxas de fluxo
  # sejam > zero
  def get_neighbors(valve, dists, graph) do
    dists[valve]
    |> Enum.map(fn {k, _} -> k end)
    |> Enum.reject(fn item -> graph[item][:flow_rate] === 0 end)
  end
end
