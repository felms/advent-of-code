defmodule Day12 do
  @moduledoc """
  Dia 12 do Advent of Code de 2015
  """
  def run() do
    input_file = "input.txt"

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")

    {time, result} = :timer.tc(&part01/1, [input])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part02/1, [input])

    IO.puts(
      "\n==Part 02== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

  end

  # - Problema 01
  def part01(input) do
    Regex.scan(~r/-?\d+/, input)
    |> Enum.map(fn [x] -> String.to_integer(x) end)
    |> Enum.sum
  end

  # - Problema 02
  def part02(input) do
    input |> Jason.decode! |> exec_sum
  end

  defp exec_sum(item) when is_map(item), do: sum_map(item)
  defp exec_sum(item) when is_list(item), do: sum_list(item)

  defp sum_map(map) do
    values = map |> Map.values

    if Enum.member?(values, "red") do
      0
    else
      sum_list(values)
    end
  end

  defp sum_list([]), do: 0
  defp sum_list([h | t]) when is_map(h), do: sum_map(h) + sum_list(t)
  defp sum_list([h | t]) when is_list(h), do: sum_list(h) + sum_list(t)
  defp sum_list([h | t]) when is_integer(h), do: h + sum_list(t)
  defp sum_list([_ | t]), do: sum_list(t)
end

# ---- Run

Day12.run