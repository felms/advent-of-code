defmodule Day16 do
  @moduledoc """
  Dia 16 do Advent of Code de 2022
  """
  
  Code.require_file("tunnels.ex")
  
  def run(mode \\ :test) do
    case mode do
      :test -> solve("sample_input.txt")
      :input -> solve("input.txt")
    end
  end

  defp solve(input_file) do
    graph = parse_input(input_file)

    dists =
      graph
      |> Tunnels.calc_distances()

    {time, result} = :timer.tc(&Tunnels.pressure_release/5, [graph, 30, "AA", dists, []])

    IO.puts(
      "==Part 01== \nResult:\n#{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
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

    {name, %{flow_rate: String.to_integer(flow_rate), tunnels: parse_tunnels(tunnels)}}
  end

  # - Cria a lista com os túneis acessiveis
  # apartir do ponto atual
  defp parse_tunnels(tunnels_string) do
    tunnels_string
    |> String.replace(~r/tunnels? leads? to valves? /, "")
    |> String.split(", ", trim: true)
  end
end

# --- Run
System.argv()
|> hd
|> String.to_atom
|> Day16.run()