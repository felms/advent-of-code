defmodule Day06 do
  @moduledoc """
  Dia 06 do Advent of Code 2023
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

  def part_02(input) do
    input
    |> Enum.reduce(["", ""], fn {t, r}, [acc_t, acc_r] ->
      [
        acc_t <> Integer.to_string(t),
        acc_r <> Integer.to_string(r)
      ]
    end)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
    |> ways_to_beat_the_record()
  end

  def ways_to_beat_the_record({time, record}) do
    0..time
    |> Enum.reduce(0, fn holding_time, acc ->
      distance = holding_time * (time - holding_time)

      if distance > record do
        acc + 1
      else
        acc
      end
    end)
  end
end

# ---- Run
System.argv
|> hd
|> Day06.run