defmodule Day09 do
  @moduledoc """
  Dia 09 do Advent of Code 2023
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

  def parse_input(input_string) do
    input_string
    |> String.split("\n", trim: true)
    |> Enum.map(fn list ->
      list |> String.split(~r/\s+/, trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end

  # - Problema 01
  def part_01(input) do
    input
    |> Enum.map(&predict_next_value/1)
    |> Enum.map(&(&1 |> List.last()))
    |> Enum.sum()
  end

  def predict_next_value(values) do
    [values]
    |> calc_differences_list()
    |> collapse_lists()
  end

  def calc_differences_list(lists) do
    last_list = lists |> List.last()

    if last_list |> Enum.all?(&(&1 == 0)) do
      lists
    else
      diff_list =
        last_list
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn [a, b] -> b - a end)

      calc_differences_list(List.insert_at(lists, -1, diff_list))
    end
  end

  def collapse_lists(lists) do
    [first_list | rest] = lists |> Enum.reverse()
    get_last_value([first_list |> List.insert_at(-1, 0) | rest])
  end

  def get_last_value(lists) do
    if length(lists) == 1 do
      lists |> hd
    else
      [first_list, second_list | rest] = lists
      new_value = Enum.at(first_list, -1) + Enum.at(second_list, -1)

      get_last_value([second_list |> List.insert_at(-1, new_value) | rest])
    end
  end
end
