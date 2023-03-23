defmodule Day16 do
  @moduledoc """
  Dia 16 do Advent of Code de 2022
  """
  def part_01(mode \\ :test) do
    case mode do
      :test -> run("sample_input.txt")
      :input -> run("input.txt")
    end
  end

  defp run(input_file) do
    graph =
      parse_input(input_file)
      |> Tunnels.calc_distances()
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
    |> Enum.map(&parse_valve/1)
    |> Enum.into(%{})
  end

  # - Parse de uma 'válvula' do input separando em
  # nome e taxa de fluxo
  defp parse_valve(valve_string) do
    %{"name" => name, "flow_rate" => flow_rate, "tunnels" => tunnels} =
      Regex.named_captures(
        ~r/Valve (?<name>[A-Z]{2}) has flow rate=(?<flow_rate>\d+); (?<tunnels>tunnels?.*)/,
        valve_string
      )

    {name, %{flow_rate: flow_rate, tunnels: parse_tunnels(tunnels)}}
  end

  # - Cria a lista com os túneis acessiveis
  # apartir do ponto atual
  defp parse_tunnels(tunnels_string) do
    tunnels_string
    |> String.replace(~r/tunnels? leads? to valves? /, "")
    |> String.split(", ", trim: true)
  end
end
