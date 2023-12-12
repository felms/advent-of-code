defmodule Day12 do
  @moduledoc """
  Dia 12 do Advent of Code 2023
  """

  def run(input_file) do

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
  end

  # - Problema 01
  def part_01(input) do
    input
    |> Enum.map(&count_possible_arrangements/1)
    |> Enum.sum()
  end

  def parse_input(input_string) do
    input_string
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_record/1)
  end

  def parse_record(record) do
    record
    |> String.split(~r/\s+/, trim: true)
    |> List.to_tuple()
  end

  # - Gera o "relatório de molas danificadas" com
  # base em um input
  def generate_damaged_spring_report(springs_list) do
    springs_list
    |> String.split(".", trim: true)
    |> Enum.map(fn str -> str |> String.length() |> Integer.to_string() end)
    |> Enum.join(",")
  end

  # - Testa se uma combinação gerada bate
  # o padrão
  def matches?(combination, pattern) do
    combination
    |> generate_damaged_spring_report()
    |> then(&(&1 == pattern))
  end

  # - Conta o número de possíveis arranjos
  # que batem com o critério
  def count_possible_arrangements({springs_list, damaged_springs}) do
    count_possible_arrangements(springs_list |> String.graphemes(), "", damaged_springs)
  end

  def count_possible_arrangements([], current_arrengement, pattern) do
    if matches?(current_arrengement, pattern), do: 1, else: 0
  end

  def count_possible_arrangements([current_spring | springs_list], current_arrengement, pattern) do
    if current_spring == "?" do
      a = count_possible_arrangements(springs_list, current_arrengement <> "#", pattern)

      b = count_possible_arrangements(springs_list, current_arrengement <> ".", pattern)

      a + b
    else
      count_possible_arrangements(springs_list, current_arrengement <> current_spring, pattern)
    end
  end
end

# ---- Run
System.argv
|> hd
|> Day12.run