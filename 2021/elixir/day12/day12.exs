defmodule Day12 do
  @moduledoc """
  Dia 12 do Advent of Code de 2021 
  """

  Code.require_file("cave.exs")

  # Roda o problema no modo correto (teste ou real)
  def run(:small), do: solve("small_input.txt")
  def run(:mid), do: solve("mid_input.txt")
  def run(:sample), do: solve("sample_input.txt")
  def run(:real), do: solve("input.txt")

  defp solve(input_file) do
    input = parse_input(input_file)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult:\n#{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "==Part 02== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  defp parse_input(file) do
    File.read!(file)
    # Para evitar problemas no Windows
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_entry/1)
    |> create_graph()
  end

  defp parse_entry(entry) do
    [from, to] = String.split(entry, "-")
    {from, to}
  end

  defp create_graph(entries), do: create_graph(entries, %{})
  defp create_graph([], graph), do: graph

  defp create_graph([{from, to} | entries], graph) do
    from_tunnels = Map.get(graph, from, [])
    to_tunnels = Map.get(graph, to, [])

    create_graph(
      entries,
      Map.put(graph, from, [to | from_tunnels]) |> Map.put(to, [from | to_tunnels])
    )
  end

  # ======= Problema 01 
  # Gerar todos os caminhos possíves de "start" 
  # até "end" passando por cada _caverna pequena_
  # no máximo um vez.
  def part_01(input) do
    input
    |> Cave.list_paths()
    |> length()
  end

  # ======= Problema 02 
  # Gerar todos os caminhos possíves de "start" 
  # até "end" passando por uma _caverna pequena_
  # duas vezes e pelas outras no máximo um vez.
  def part_02(input) do
    input
    |> Cave.list_paths_2()
    |> length()
  end
end

# ---- Run
System.argv
|> hd
|> String.to_atom
|> Day12.run
