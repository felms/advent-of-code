defmodule Day05 do
  @moduledoc """
  Dia 05 do Advent of Code 2024
  """

  def run(mode \\ nil) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> parse_input

    part_01(input)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  def part_01([rules, updates]) do
    updates
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> Enum.filter(&update_ok?(&1, rules))
    |> Enum.map(&(Enum.at(&1, div(length(&1), 2)) |> String.to_integer()))
    |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> then(&[&1 |> List.first() |> parse_rules | &1 |> tl])
  end

  def parse_rules(rules) do
    rules
    |> Enum.reduce(%{}, fn rule, acc ->
      [number_before, number_after] = rule |> String.split("|")
      current_values = Map.get(acc, number_after, [])
      Map.put(acc, number_after, [number_before | current_values])
    end)
    |> Map.to_list()
  end

  def update_ok?(update, rules) do
    rules
    |> Enum.all?(&rule_ok?(update, &1))
  end

  def rule_ok?(update, {page, pages_before}) do
    page_index = Enum.find_index(update, &(&1 == page))

    page not in update ||
      (page in update &&
         pages_before
         |> Enum.all?(fn rule_page ->
           rule_page not in update || Enum.find_index(update, &(&1 == rule_page)) < page_index
         end))
  end
end
