defmodule Day06 do
  @moduledoc """
  Dia 06 do Advent of Code 2023
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
      "==Part 01== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

  end

  def parse_input(input_string) do
    [times, record_distances] = input_string |> String.split("\n", trim: true)

    times_list =
      times
      |> String.replace(~r/Time:\s+/, "")
      |> String.split(~r/\s+/)
      |> Enum.map(&String.to_integer/1)

    dists_list =
      record_distances
      |> String.replace(~r/Distance:\s+/, "")
      |> String.split(~r/\s+/)
      |> Enum.map(&String.to_integer/1)

    Enum.zip(times_list, dists_list)
  end

  def part_01(input) do
    input
    |> Enum.map(&ways_to_beat_the_record/1)
    |> Enum.product()
  end

  def ways_to_beat_the_record({time, record}) do
    time
    |> find_possible_distances()
    |> Enum.filter(&(&1 > record))
    |> Enum.count()
  end

  def find_possible_distances(time) do
    0..time
    |> Enum.to_list()
    |> Enum.reduce([], fn holding_time, acc ->
      distance = holding_time * (time - holding_time)
      [distance | acc]
    end)
  end
end
