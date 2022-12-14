defmodule Day16 do
  @moduledoc """
  Dia 16 do Advento of Code de 2022
  """
  def part_01(mode \\ :test) do
    case mode do
      :test -> run("sample_input.txt")
      :input -> run("input.txt")
    end
  end

  defp run(input_file) do
    graph = parse_input(input_file)

    dists = Tunnels.calc_distances(graph)
    Tunnels.pressure_release(graph, 30, "AA", dists, [])
  end

  # - Faz o parse do input e gera uma tabela com
  # com o nome, taxa de fluxo e vizinhos
  # para cada válvula
  defp parse_input(input_file) do
    input_file
    |> File.read!()
    # Para evitar problemas no Windows
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn scan, acc ->
      [valve_string, tunnels_string] = String.split(scan, ";", trim: true)

      valve = parse_valve(valve_string)
      valve_name = Map.get(valve, "valve")
      flow_rate = Map.get(valve, "flow_rate") |> String.to_integer()
      tunnels = parse_tunnels(tunnels_string)

      curr_valve = %{
        flow_rate: flow_rate,
        tunnels: tunnels
      }

      Map.put(acc, valve_name, curr_valve)
    end)
  end

  # - Parse de uma 'válvula' do input separando em
  # nome e taxa de fluxo
  defp parse_valve(valve_string) do
    Regex.named_captures(
      ~r/Valve (?<valve>[A-Z]{2}) has flow rate=(?<flow_rate>\d+)/,
      valve_string
    )
  end

  # - Cria a lista com os túneis acessiveis
  # apartir do ponto atual
  defp parse_tunnels(tunnels_string) do
    tunnels_string
    |> String.replace(~r/.*(valve |valves )/, "")
    |> String.replace(" ", "")
    |> String.split(",", trim: true)
  end
end
