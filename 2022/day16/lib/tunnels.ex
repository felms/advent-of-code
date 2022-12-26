defmodule Tunnels do

  def dfs(graph, source) do
    s = [{source, 0}]
    find_path(graph, s, [], 0, [], 30)
  end

  def find_path(_, _, _, current_flow, flows, 0), do: {current_flow, flows}
  def find_path(_, [], _, current_flow, flows, _), do: {current_flow, flows}
  def find_path(graph, s, discovered, current_flow, flows, minutes) do
    {{v, v_flow}, new_queue} = List.pop_at(s, 0)
    neighbors = get_neighbors(v, graph)
    |> Enum.reject(fn {item, _} -> Enum.member?(discovered, item) end)
    |> Enum.sort(fn {_, flow0},{_, flow1} -> flow0 >= flow1 end)

    IO.inspect(v)
    IO.inspect(neighbors)

    new_discovered = [v | discovered]
    new_s = neighbors ++ new_queue

    if v_flow > 0 do
      new_flow = current_flow + v_flow
      find_path(graph, new_s, new_discovered, new_flow, [new_flow | flows], minutes - 2)
    else
      find_path(graph, new_s, new_discovered, current_flow, [current_flow | flows], minutes - 1)
    end

  end

  def get_neighbors(tunnel, graph) do
    list = Map.get(graph, tunnel) |> Map.get(:tunnels)

    Enum.reduce(list, [], fn t, acc ->
      flow = Map.get(graph, t) |> Map.get(:flow_rate)
      [{t, flow}] ++ acc
    end)
  end
end
