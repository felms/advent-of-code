defmodule Dijkstra do
  @moduledoc """
  Implementa o Algoritmo de Dijkstra.
  """

  Code.require_file("pqueue.exs")

  @type priority_queue :: {heap :: list(), size :: integer()}

  defguard is_empty(pqueue) when pqueue.size == 0

  @infinity 1_000_000_000

  @doc """
  Gera um mapa com a mínima distancia de source a todos
  os outros pontos do grafo.
  """
  @spec find_min_distances(graph :: map(), source :: tuple()) :: map()
  def find_min_distances(graph, source) do
    dist =
      graph
      |> Map.keys()
      |> Enum.map(&{&1, @infinity})
      |> Map.new()
      |> Map.put(source, 0)

    pqueue = PQueue.new([{source, 0}])

    find_min_distances(graph, pqueue, dist)
  end

  @spec find_min_distances(graph :: map(), pqueue :: priority_queue(), dists :: map()) :: map()
  defp find_min_distances(_graph, pqueue, dist) when is_empty(pqueue), do: dist

  defp find_min_distances(graph, pqueue, dist) do
    {updated_pqueue, {u, _u_priority}} = PQueue.poll(pqueue)
    neighbors = find_neighbors(graph, u)

    {new_queue, new_dist} = process_neighbors(graph, updated_pqueue, dist, u, neighbors)

    find_min_distances(graph, new_queue, new_dist)
  end

  # -- Faz a função do 'for' no Algoritmo de Dijkstra.
  # -- Processa todos os vizinhos de um ponto.
  @spec process_neighbors(
          graph :: map(),
          pqueue :: priority_queue(),
          dist :: map(),
          point :: tuple(),
          neighbors :: list()
        ) :: tuple()
  defp process_neighbors(_graph, pqueue, dist, _point, []), do: {pqueue, dist}

  defp process_neighbors(graph, pqueue, dist, point, [v | neighbors]) do
    alt = Map.get(dist, point) + Map.get(graph, v)

    if alt < Map.get(dist, v) do
      new_dist = Map.put(dist, v, alt)
      new_queue = PQueue.insert(pqueue, {v, alt})
      process_neighbors(graph, new_queue, new_dist, point, neighbors)
    else
      process_neighbors(graph, pqueue, dist, point, neighbors)
    end
  end

  # -- Encontra todos os vizinhos de um ponto.
  @spec find_neighbors(graph :: map(), point :: tuple()) :: list()
  defp find_neighbors(graph, {x, y}),
    do: [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}] |> Enum.filter(&Map.has_key?(graph, &1))
end
