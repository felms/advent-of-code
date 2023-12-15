defmodule Day12.Part02 do
  @moduledoc """
  Parte 02 do dia 12 do Advent of Code 2023
  """

  def run(mode \\ :real_input) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> parse_input()

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  # - Problema 02
  def part_02(input) do
    input
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
      ("." <> record <> ".") |> String.graphemes(),
      groups_string
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
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
  def count_possible_arrangements({record, group}), do: count_possible_arrangements(record, group)

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
          count_possible_arrangements(
            ["." | record |> Enum.drop(pos + current_group + 1)],
            groups
          )
      else
        acc
      end
    end)
  end
end
