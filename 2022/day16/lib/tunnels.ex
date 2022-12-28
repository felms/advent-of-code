defmodule Tunnels do
  def pressure_release(graph, time, valve, dists, open_valves) do
    neighbors = 
      get_neighbors(valve, dists, graph)


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
    Enum.reduce(graph, %{}, fn {key, _}, acc ->
      Map.put(acc, key, dfs(graph, key, [], %{}, 0))
    end)
  end

  # - Usa o algoritmo DFS para calcular as distancias
  # de um vértice (válvula) para todos os outros no
  # no grafo (conjunto de tuneis)
  defp dfs(graph, source, discovered, res, dist) do
    current_discovered = [source | discovered]
    current_res = Map.put(res, source, dist)

    neighbors =
      graph[source][:tunnels]
      |> Enum.reject(fn valve -> Enum.member?(current_discovered, valve) end)
      |> Enum.reject(fn valve -> Map.has_key?(current_res, valve) end)

    Enum.reduce(neighbors, current_res, fn neighbor, acc ->
      dfs(graph, neighbor, current_discovered, acc, dist + 1)
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
