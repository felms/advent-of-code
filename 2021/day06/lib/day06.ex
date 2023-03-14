defmodule Day06 do
  @moduledoc """
  Dia 06 do Advent of Code de 2021
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
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp part_01(input) do
    input
    |> simulate_days(80, 0)
    |> length()
  end

  defp simulate_days(fish, x, x), do: fish

  defp simulate_days(fish, number_of_days, current_day),
    do: simulate_day(fish, [], []) |> simulate_days(number_of_days, current_day + 1)

  defp simulate_day([], processed, spawn_fish), do: (spawn_fish ++ processed) |> Enum.reverse()

  defp simulate_day([0 | school], processed, spawn_fish),
    do: simulate_day(school, [6 | processed], [8 | spawn_fish])

  defp simulate_day([fish | school], processed, spawn_fish),
    do: simulate_day(school, [fish - 1 | processed], spawn_fish)
end
