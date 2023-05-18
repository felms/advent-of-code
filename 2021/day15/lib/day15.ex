defmodule Day15 do
  @moduledoc """
  Dia 15 do Advent of Code de 2021
  """

  # Roda o problema no modo correto (teste ou real)
  def run(), do: solve("sample_input.txt")
  def run(:real), do: solve("input.txt")

  # Chama o método para a solução do problema
  defp solve(input_file) do
    input = parse_input(input_file)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult:\n#{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    # {time, result} = :timer.tc(&part_02/1, [input])

    # IO.puts(
    #   "==Part 02== \nResult: \n\n#{result}" <>
    #     "\n\nCalculated in #{time / 1_000_000} seconds\n"
    # )
  end

  defp parse_input(file) do
    File.read!(file)
    # Para evitar problemas no Windows
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(&parse_row/1)
    |> List.flatten()
    |> Map.new()
  end

  defp parse_row({row, y}) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {value, x} -> {{x, y}, String.to_integer(value)} end)
  end

  # ======= Problema 01
  defp part_01(input) do
    {min_x, max_x} =
      input
      |> Map.keys()
      |> Enum.map(fn {x, _y} -> x end)
      |> Enum.min_max()

    {min_y, max_y} =
      input
      |> Map.keys()
      |> Enum.map(fn {_x, y} -> y end)
      |> Enum.min_max()

    source = {min_x, min_y}
    dest = {max_x, max_y}

    dists = Dijkstra.find_min_distances(input, source)

    dists[dest]
  end
end
