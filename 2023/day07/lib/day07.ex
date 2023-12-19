defmodule Day07 do
  @moduledoc """
  Dia 07 do Advent of Code 2023
  """

  def run(mode \\ :real_input) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")

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

  # - Parte 01 do problema
  def part_01(input_string) do
    input_string
    |> String.split("\n", trim: true)
    |> Enum.map(&Hand.new/1)
    |> Enum.sort(Hand)
    |> Enum.map(& &1.bid)
    |> Enum.with_index(1)
    |> Enum.map(fn {bid, rank} -> bid * rank end)
    |> Enum.sum()
  end

  # - Parte 02 do problema
  def part_02(input_string) do
    input_string
    |> String.split("\n", trim: true)
    |> Enum.map(&Hand.new_02/1)
    |> Enum.sort(Hand)
    |> Enum.map(& &1.bid)
    |> Enum.with_index(1)
    |> Enum.map(fn {bid, rank} -> bid * rank end)
    |> Enum.sum()
  end
end
