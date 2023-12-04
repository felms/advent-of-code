defmodule Day04 do
  @moduledoc """
  Dia 04 do Advent of Code 2023
  """

  def run(input_file) do

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

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "==Part 02== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
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

  # Problema 02
  def part_02(input) do
    state = input |> create_state()

    process_cards(1, Enum.count(state), state)
    |> Enum.map(fn {_k, v} -> v.copies end)
    |> Enum.sum()
  end

  def create_state(cards) do
    Enum.reduce(cards, %{}, fn card, acc ->
      acc
      |> Map.put(String.to_integer(card.card_number), %{
        card_number: card.card_number,
        winning_numbers: card.winning_numbers,
        card_numbers: card.card_numbers,
        copies: 1
      })
    end)
  end

  def update_state(current_to_update, last_to_update, _copies, state)
      when current_to_update > last_to_update,
      do: state

  def update_state(current_to_update, last_to_update, copies, state) do
    card_to_update = state[current_to_update]
    new_card = %{card_to_update | copies: card_to_update.copies + copies}

    update_state(
      current_to_update + 1,
      last_to_update,
      copies,
      Map.put(state, current_to_update, new_card)
    )
  end

  def process_cards(current_card, last_card, state) when current_card > last_card, do: state

  def process_cards(current_card, last_card, state) do
    card = state[current_card]
    matches = card_matches(card)

    new_state = update_state(current_card + 1, current_card + matches, card.copies, state)

    process_cards(current_card + 1, last_card, new_state)
  end

  def card_matches(card) do
    card.card_numbers
    |> Enum.count(&(&1 in card.winning_numbers))
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

# ---- Run
System.argv
|> hd
|> Day04.run