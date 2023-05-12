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

    # {time, result} = :timer.tc(&part_01/1, [input])

    # IO.puts(
    #   "==Part 01== \nResult:\n#{result}" <>
    #     "\nCalculated in #{time / 1_000_000} seconds\n"
    # )

    # {time, result} = :timer.tc(&part_02/1, [input])

    # IO.puts(
    #   "==Part 02== \nResult: \n\n#{result}" <>
    #     "\n\nCalculated in #{time / 1_000_000} seconds\n"
    # )
  end

  defp parse_input(file) do
    template =
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
    |> Enum.map(fn {value, x} -> {{x, y}, value} end)
  end

  # ======= Problema 01
  # defp part_01() do
  # end
end
