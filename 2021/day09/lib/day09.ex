defmodule Day09 do
  @moduledoc """
  Dia 09 do Advent of Code de 2021
  """
  @high_point 1_000_000

  # Roda o problema no modo correto (teste ou real)
  def run(:sample), do: solve("sample_input.txt")
  def run(:real), do: solve("input.txt")

  # Chama o método para a solução do problema
  defp solve(input_file) do
    input = parse_input(input_file)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    # {time, result} = :timer.tc(&part_02/1, [input])

    # IO.puts(
    #   "==Part 02== \nResult: #{result}" <>
    #     "\nCalculated in #{time / 1_000_000} seconds\n"
    # )
  end

  defp parse_input(file) do
    File.read!(file) 
    |> String.replace("\r", "")  # Para evitar problemas no Windows 
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {value, index} -> {index, parse_row(value)} end)
    |> Enum.map(&to_matrix/1)
    |> List.flatten()
    |> Enum.into(%{})
  end

  defp part_01(input) do
    input
    |> Map.keys()
    |> Enum.filter(&(low_point?(&1, input)))
    |> Enum.map(&(risk_level(&1, input)))
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
    ] |> Enum.reject(&(&1 == nil))

  end
end
