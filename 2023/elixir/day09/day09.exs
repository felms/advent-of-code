defmodule Day09 do
  @moduledoc """
  Dia 09 do Advent of Code 2023
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

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "\n==Part 02== \n\nResult: #{result}" <>
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

  # - Problema 02
  def part_02(input) do
    input
    |> Enum.map(&predict_first_value/1)
    |> Enum.map(&(&1 |> hd()))
    |> Enum.sum()
  end

  def predict_next_value(values) do
    [values]
    |> calc_differences_list()
    |> collapse_lists()
  end

  def predict_first_value(values) do
    [values]
    |> calc_differences_list()
    |> collapse_lists_2()
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

  def collapse_lists_2(lists) do
    [first_list | rest] = lists |> Enum.reverse()
    get_first_value([[0 | first_list] | rest])
  end

  def get_first_value(lists) do
    if length(lists) == 1 do
      lists |> hd
    else
      [first_list, second_list | rest] = lists
      new_value = hd(second_list) - hd(first_list)

      get_first_value([[new_value | second_list] | rest])
    end
  end
end

# ---- Run
System.argv
|> hd
|> Day09.run