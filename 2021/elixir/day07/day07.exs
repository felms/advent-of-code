defmodule Day07 do
  @moduledoc """
  Dia 07 do Advent of Code de 2021
  """

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
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp part_01(input) do
    median = input |> median()

    input
    |> Enum.map(&((&1 - median) |> abs()))
    |> Enum.sum()
  end

  defp part_02(input) do
    {min, max} = Enum.min_max(input)

    Enum.map(min..max, &total_cost(input, &1))
    |> Enum.min()
  end

  defp total_cost(input, target_pos) do
    input
    |> Enum.map(&fuel_cost(&1, target_pos))
    |> Enum.sum()
  end

  defp median(list), do: median(Enum.sort(list), length(list))

  defp median(list, length) when rem(length, 2) == 0 do
    pos_1 = div(length, 2)
    pos_2 = pos_1 - 1
    (Enum.at(list, pos_1) + Enum.at(list, pos_2)) |> div(2)
  end

  defp median(list, length) do
    pos = div(length, 2)
    Enum.at(list, pos)
  end

  defp fuel_cost(current_pos, target_pos) do
    diff = (current_pos - target_pos) |> abs
    1..diff |> Enum.sum()
  end
end

# ---- Run
System.argv
|> hd
|> Day07.run
