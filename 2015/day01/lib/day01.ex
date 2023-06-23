defmodule Day01 do
  @moduledoc """
  Dia 01 do Advent of Code de 2015
  """

  def run() do
    input = parse_input("input.txt")

    {time, result} = :timer.tc(&part_01/1, [input])

    # IO.puts(
    #   "==Part 01== \nResult:\n#{result}" <>
    #     "\nCalculated in #{time / 1_000_000} seconds\n"
    # )

    #  {time, result} = :timer.tc(&part_02/1, [input])

    #  IO.puts(
    #    "==Part 02== \nResult: \n\n#{result}" <>
    #      "\nCalculated in #{time / 1_000_000} seconds\n"
    #  )
  end

  defp parse_input(file) do
    File.read!(file)
    |> String.graphemes()
  end

  # ======= Problema 01
  defp part_01(input) do
    input
    |> count(0)
  end

  defp count([], counter), do: counter
  defp count(["(" | tail], counter), do: count(tail, counter + 1)
  defp count([")" | tail], counter), do: count(tail, counter - 1)

  # ======= Problema 02
end

