defmodule Day15 do
  @moduledoc """
  Dia 15 do Advent of Code 2023
  """

  def run(mode \\ :real_input) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

    input = File.read!(input_file)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  def part_01(input) do
    input
    |> String.replace("\n", "")
    |> String.split(",", trim: true)
    |> Enum.map(&get_hash/1)
    |> Enum.sum()
  end

  def get_hash(input_string) do
    input_string
    |> String.graphemes()
    |> Enum.reduce(0, fn letter, current_value ->
      (current_value + get_ascii_code(letter))
      |> then(&(&1 * 17))
      |> then(&rem(&1, 256))
    end)
  end

  def get_ascii_code(letter), do: letter |> String.to_charlist() |> hd
end
