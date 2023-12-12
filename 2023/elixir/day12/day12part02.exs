defmodule Day12Part02 do
  @moduledoc """
  Parte 02 do dia 12 do Advent of Code 2023
  """
  use Agent # Para usar o cache

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def run(input_file) do

    start_link()

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> parse_input()

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "\n==Part 02== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  # - Problema 01
  def part_01(input) do
    input
    |> Enum.map(&count_possible_arrangements/1)
    |> Enum.sum()
  end

  # - Problema 02
  def part_02(input) do
    input
    |> Enum.map(&unfold/1)
    |> Enum.map(&count_possible_arrangements/1)
    |> Enum.sum()
  end

  def parse_input(input_string) do
    input_string
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  def parse_row(row) do
    [record, groups_string] = row |> String.split(~r/\s+/, trim: true)

    {
      record |> String.graphemes(),
      groups_string
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
    }
  end

  # - "Desdobra" um registro
  def unfold({record, groups}) do
    {
      record |> List.duplicate(5) |> Enum.intersperse(["?"]) |> List.flatten(),
      groups |> List.duplicate(5) |> List.flatten()
    }
  end

  # - Testa se um grupo cabe em um registro
  def fits?([], _position, _group), do: false

  def fits?(record, position, group) do
    size = record |> length()

    cond do
      group > size -> false
      position + group >= size -> false
      record |> Enum.drop(position) |> Enum.take(group) |> Enum.any?(&(&1 == ".")) -> false
      record |> Enum.take(position) |> Enum.any?(&(&1 == "#")) -> false
      record |> Enum.at(position + group) == "#" -> false
      true -> true
    end
  end

  # - Conta o número de possíveis arranjos
  # que batem com o critério
  def count_possible_arrangements({record, group}),
    do: cached_count(["."] ++ record ++ ["."], group)

  def count_possible_arrangements([], []), do: 1
  def count_possible_arrangements([], _group), do: 0

  def count_possible_arrangements(record, []) do
    if "#" in record, do: 0, else: 1
  end

  def count_possible_arrangements(record, [current_group | groups]) do
    size = record |> length()

    0..size
    |> Enum.reduce(0, fn pos, acc ->
      if fits?(record, pos, current_group) do
        acc +
          cached_count(
            ["." | record |> Enum.drop(pos + current_group + 1)],
            groups
          )
      else
        acc
      end
    end)
  end

  # - Conta o número de possíveis arranjos
  # que batem com o critério utilizando um Dicionário
  # como cache
  def cached_count(record, group) do
    key = "key:#{record |> List.to_string}-#{group |> List.to_string}"

    res = Agent.get(__MODULE__, & (Map.get(&1, key)))

    if res do
      res
    else
      calculated_res = count_possible_arrangements(record, group)
      Agent.update(__MODULE__, &(Map.put(&1, key, calculated_res)))
      calculated_res
    end
  end


end

# ---- Run
System.argv
|> hd
|> Day12Part02.run