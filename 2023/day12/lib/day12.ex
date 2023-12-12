defmodule Day12 do
  @moduledoc """
  Dia 12 do Advent of Code 2023
  """

  def run(mode \\ :real_input) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

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

  # - Conta o número de possíveis arranjos
  # que batem com o critério
  def count_possible_arrangements({springs_list, damaged_springs}) do
    springs_list
    |> generate_arrangements()
    |> Enum.map(&generate_damaged_spring_report/1)
    |> Enum.filter(&(&1 == damaged_springs))
    |> Enum.count()
  end

  # - Gera o "relatório de molas danificadas" com
  # base em um input
  def generate_damaged_spring_report(springs_list) do
    springs_list
    |> String.split(".", trim: true)
    |> Enum.map(fn str -> str |> String.length() |> Integer.to_string() end)
    |> Enum.join(",")
  end

  # - Gera todos os possíveis arranjos
  # dado um possível input
  def generate_arrangements(spring_list) do
    generate_arrangements(spring_list, String.length(spring_list), 0, "", [])
  end

  def generate_arrangements(_, list_length, position, current_arrengement, arrengements_list)
      when position >= list_length,
      do: arrengements_list ++ [current_arrengement]

  def generate_arrangements(
        spring_list,
        list_length,
        position,
        current_arrengement,
        arrengements_list
      ) do
    case String.at(spring_list, position) do
      "?" ->
        generate_arrangements(
          spring_list,
          list_length,
          position + 1,
          current_arrengement <> "#",
          arrengements_list
        ) ++
          generate_arrangements(
            spring_list,
            list_length,
            position + 1,
            current_arrengement <> ".",
            arrengements_list
          )

      x ->
        generate_arrangements(
          spring_list,
          list_length,
          position + 1,
          current_arrengement <> x,
          arrengements_list
        )
    end
  end
end
