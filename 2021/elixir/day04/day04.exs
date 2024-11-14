defmodule Day04 do
  @moduledoc """
  Dia 04 do Advent of Code de 2021
  """

  Code.require_file("bingo.exs")

  def run(input_file) do
    input = parse_input(input_file)

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

  defp parse_input(file) do
    [numbers | boards] =
      File.read!(file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.split("\n\n", trim: true)

    %{
      numbers: numbers |> String.split(",", trim: true),
      boards: boards |> Enum.map(&parse_board/1)
    }
  end

  defp parse_board(board) do
    board
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
  end

  # ===== PART 01
  defp part_01(input) do
    Bingo.play(input.numbers, input.boards)
  end

  # ===== PART 02
  defp part_02(input) do
    Bingo.last_winning_board(input.numbers, input.boards)
  end
end

# ---- Run
System.argv
|> hd
|> Day04.run
