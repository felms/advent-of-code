defmodule Day06 do
  @moduledoc """
  Dia 06 do Advent of Code de 2021
  """
  @age_classes %{0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0}

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
    input
    |> fill_age_classes()
    |> simulate_days(80, 0)
    |> Enum.reduce(0, fn {_k, v}, acc -> v + acc end)
  end

  defp part_02(input) do
    input
    |> fill_age_classes()
    |> simulate_days(256, 0)
    |> Enum.reduce(0, fn {_k, v}, acc -> v + acc end)
  end

  defp fill_age_classes(list), do: fill_age_classes(list, %{})
  defp fill_age_classes([], classes), do: classes

  defp fill_age_classes([fish | school], classes) do
    fill_age_classes(school, Map.put(classes, fish, Map.get(classes, fish, 0) + 1))
  end

  defp simulate_days(age_classes, x, x), do: age_classes

  defp simulate_days(age_classes, number_of_days, current_day) do
    simulate_day(age_classes) |> simulate_days(number_of_days, current_day + 1)
  end

  defp simulate_day(age_classes), do: age_classes |> Map.to_list() |> simulate_day([], [])
  defp simulate_day([], processed, spawn_fish), do: (spawn_fish ++ processed) |> list_to_map()

  defp simulate_day([{0, v} | school], processed, spawn_fish),
    do: simulate_day(school, [{6, v} | processed], [{8, v} | spawn_fish])

  defp simulate_day([{fish, v} | school], processed, spawn_fish),
    do: simulate_day(school, [{fish - 1, v} | processed], spawn_fish)

  defp list_to_map(input), do: list_to_map(input, @age_classes)
  defp list_to_map([], acc), do: acc

  defp list_to_map([{k, v} | classes], acc) do
    list_to_map(classes, Map.put(acc, k, Map.get(acc, k) + v))
  end
end

# ---- Run
System.argv
|> hd
|> Day06.run