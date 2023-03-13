defmodule Day05 do
  @moduledoc """
  Dia 05 do Advent of Code de 2021
  """

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
    # Para evitar problemas no Windows
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
  end

  defp part_01(input) do
    input
    |> Enum.map(&parse_segment/1)
    |> Enum.filter(fn [[x1, y1], [x2, y2]] -> x1 == x2 or y1 == y2 end)
    |> Enum.map(&create_segment/1)
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.filter(fn {_k, v} -> v >= 2 end)
    |> length()
  end

  defp create_segment([[x1, y1], [x2, y2]]), do: for(x <- x1..x2, y <- y1..y2, do: {x, y})

  defp parse_segment(line) do
    line
    |> String.split(" -> ", trim: true)
    |> Enum.map(&parse_point/1)
  end

  defp parse_point(point) do
    point
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
