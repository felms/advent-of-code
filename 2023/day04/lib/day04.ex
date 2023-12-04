defmodule Day04 do
  @moduledoc """
  Dia 04 do Advent of Code 2023
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

    # {time, result} = :timer.tc(&part_02/1, [input])

    # IO.puts(
    #   "==Part 02== \nResult: #{result}" <>
    #     "\nCalculated in #{time / 1_000_000} seconds\n"
    # )
  end

  # Problema 01
  def part_01(input) do
    input
    |> Enum.map(fn card ->
      matches = card_matches(card)
      if matches > 0, do: Integer.pow(2, matches - 1), else: 0
    end)
    |> Enum.sum()
  end

  def card_matches(card) do
    card.card_numbers
    |> Enum.count(fn number -> number in card.winning_numbers end)
  end

  def parse_input(input_string) do
    input_string
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_card/1)
  end

  def parse_card(input) do
    [_, card_number, w, n] = Regex.run(~r/Card\s+(\d+):(.+)\|(.+)/, input)

    %{
      card_number: card_number,
      winning_numbers: w |> String.split(~r/\s+/, trim: true),
      card_numbers: n |> String.split(~r/\s+/, trim: true)
    }
  end
end
