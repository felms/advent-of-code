defmodule Day09 do
  @moduledoc """
  Dia 09 do Advent of Code de 2021
  """

  Code.require_file("cave.exs")

  @high_point 1_000_000

  def run(input_file) do
    input = parse_input(input_file)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult: #{result}" <>
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
    |> Enum.with_index()
    |> Enum.map(fn {value, index} -> {index, parse_row(value)} end)
    |> Enum.map(&to_matrix/1)
    |> List.flatten()
    |> Enum.into(%{})
  end

  # ======= Problema 01
  defp part_01(input) do
    input
    |> Map.keys()
    |> Enum.filter(&low_point?(&1, input))
    |> Enum.map(&risk_level(&1, input))
    |> Enum.sum()
  end

  defp risk_level(point, heightmap), do: heightmap[point] + 1

  defp parse_row(row) do
    row
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.map(fn {value, index} -> {index, value} end)
  end

  defp to_matrix({index, list}) do
    list
    |> Enum.map(fn {k, v} -> {{index, k}, v} end)
  end

  defp low_point?(point, heightmap) do
    point_height = heightmap[point]

    neighbors(point, heightmap)
    |> Enum.all?(&(&1 > point_height))
  end

  defp neighbors({x, y}, heightmap) do
    [
      Map.get(heightmap, {x - 1, y}, @high_point),
      Map.get(heightmap, {x + 1, y}, @high_point),
      Map.get(heightmap, {x, y - 1}, @high_point),
      Map.get(heightmap, {x, y + 1}, @high_point)
    ]
    |> Enum.reject(&(&1 == nil))
  end

  # ======= Problema 02
  defp part_02(input) do
    input
    |> Cave.find_basins()
    |> Enum.map(&MapSet.size/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end
end

# ---- Run
System.argv
|> hd
|> Day09.run
