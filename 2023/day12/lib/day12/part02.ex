defmodule Day12.Part02 do
  @moduledoc """
  Parte 02 do dia 12 do Advent of Code 2023
  """

  def run(mode \\ :real_input) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

    _input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> parse_input()
      |> Enum.map(&count_possible_arrangements/1)
  end

  def parse_input(input_string) do
    input_string
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  def parse_row(row) do
    [record, groups_string] = row |> String.split(~r/\s+/, trim: true)

    {
      record |> String.graphemes,
      groups_string
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
    }
  end

  # - Testa se um grupo cabe no inicio de
  # de um registro
  def fits?(record, group) do
    if record |> length() < group, do: false, else: record |> Enum.take(group) |> Enum.all?(& &1 in ["?", "#"])
  end

  # - Conta o número de possíveis arranjos
  # que batem com o critério
  def count_possible_arrangements({record, group}), do: count_possible_arrangements(record, group)
  def count_possible_arrangements([], []), do: 1
  def count_possible_arrangements([], _groups), do: 0
  def count_possible_arrangements(record, []) do
    if "#" in record, do: 0, else: 1
  end

  def count_possible_arrangements(record, [current_group | groups]) do

    record |> IO.inspect()
    current_group |> IO.inspect()
    groups |> IO.inspect()

    if not fits?(record, current_group) do
      0
    else
      0..((record |> length) - current_group)
      |> Enum.reduce(0, fn initial_index, acc ->
        acc + count_possible_arrangements(record |> Enum.drop(initial_index + current_group), groups)
      end)
    end

  end
end
