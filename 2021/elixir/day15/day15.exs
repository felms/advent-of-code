defmodule Day15 do
  @moduledoc """
  Dia 15 do Advent of Code de 2021
  """

  Code.require_file("dijkstra.exs")

  def run(input_file) do
    input = parse_input(input_file)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult:\n#{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "==Part 02== \nResult: \n\n#{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
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

  # ======= Problema 02
  defp part_02(input) do
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

    width = max_x + 1
    height = max_y + 1
    dest_x = width * 4 + max_x
    dest_y = height * 4 + max_y

    grid =
      for(x <- 0..dest_x, y <- 0..dest_y, do: {x, y})
      |> calc_rows(input, max_x, max_y)

    source = {min_x, min_y}
    dest = {dest_x, dest_y}

    dists = Dijkstra.find_min_distances(grid, source)

    dists[dest]
  end

  defp calc_rows([], graph, _max_x, _max_y), do: graph

  defp calc_rows([{x, y} = point | points], graph, max_x, max_y) do
    cond do
      x <= max_x and y <= max_y ->
        calc_rows(points, graph, max_x, max_y)

      y <= max_y ->
        item = 1 + graph[{x - max_x - 1, y}]
        value = if item > 9, do: 1, else: item
        calc_rows(points, Map.put(graph, point, value), max_x, max_y)

      true ->
        item = 1 + graph[{x, y - max_y - 1}]
        value = if item > 9, do: 1, else: item
        calc_rows(points, Map.put(graph, point, value), max_x, max_y)
    end
  end
end

# ---- Run
System.argv
|> hd
|> Day15.run
