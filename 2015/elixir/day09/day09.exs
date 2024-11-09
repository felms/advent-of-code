defmodule Day09 do
  @moduledoc """
  Dia 09 do Advent of Code de 2015
  """

  def run(input_file) do

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> parse_input()

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
    cities =
      input
      |> Enum.map(fn {{from, to}, _v} -> [from, to] end)
      |> List.flatten()
      |> Enum.uniq()

    0..((cities |> length()) - 1)
    |> Enum.reduce([], fn index, acc ->
      city = Enum.at(cities, index)
      rem = List.delete_at(cities, index)
      [min_dists([city | rem], input, 0) | acc]
    end)
    |> Enum.min()
  end
  

  # - Problema 02
  def part02(input) do
    cities =
      input
      |> Enum.map(fn {{from, to}, _v} -> [from, to] end)
      |> List.flatten()
      |> Enum.uniq()

    0..((cities |> length()) - 1)
    |> Enum.reduce([], fn index, acc ->
      city = Enum.at(cities, index)
      rem = List.delete_at(cities, index)
      [max_dists([city | rem], input, 0) | acc]
    end)
    |> Enum.max()
  end


  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce([], fn distance, acc ->
      [_, from, to, dist] = Regex.run(~r/(.+) to (.+) = (\d+)/, distance)
      [{{from, to}, String.to_integer(dist)}, {{to, from}, String.to_integer(dist)} | acc]
    end)
    |> Map.new()
  end

  def min_dists([_curr_city | []], _dists, total_dist), do: total_dist

  def min_dists([curr_city | rem_cities], dists, total_dist) do
    0..((rem_cities |> length()) - 1)
    |> Enum.reduce([], fn index, acc ->
      selected_city = Enum.at(rem_cities, index)
      key = {curr_city, selected_city}
      new_dist = total_dist + Map.get(dists, key)
      [min_dists([selected_city | List.delete_at(rem_cities, index)], dists, new_dist) | acc]
    end)
    |> Enum.min()
  end
  
  def max_dists([_curr_city | []], _dists, total_dist), do: total_dist

  def max_dists([curr_city | rem_cities], dists, total_dist) do
    0..((rem_cities |> length()) - 1)
    |> Enum.reduce([], fn index, acc ->
      selected_city = Enum.at(rem_cities, index)
      key = {curr_city, selected_city}
      new_dist = total_dist + Map.get(dists, key)
      [max_dists([selected_city | List.delete_at(rem_cities, index)], dists, new_dist) | acc]
    end)
    |> Enum.max()
  end

end

# ---- Run

System.argv
|> hd
|> Day09.run
