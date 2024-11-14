defmodule Bingo do
  @marked_number "X"

  def play(numbers, boards) do
    play(numbers, boards, :continue)
  end

  defp play([number | _numbers], boards, :won),
    do: String.to_integer(number) * score_game(boards)

  defp play([number | numbers], boards, :continue) do
    updated_boards = mark_boards(number, boards)

    if game_ended?(updated_boards) do
      play([number | numbers], updated_boards, :won)
    else
      play(numbers, updated_boards, :continue)
    end
  end

  def last_winning_board(numbers, boards),
    do: last_winning_board(numbers, boards, :continue)

  defp last_winning_board([number | _numbers], boards, :found) when length(boards) == 1,
    do: String.to_integer(number) * score_game(boards)

  defp last_winning_board([number | numbers], boards, :continue) do
    updated_boards = mark_boards(number, boards)

    if game_ended?(updated_boards) do
      if length(updated_boards) == 1 do
        last_winning_board([number | numbers], updated_boards, :found)
      else
        filtered_boards =
          updated_boards
          |> Enum.reject(&(closed_row?(&1) or closed_column?(&1)))

        last_winning_board(numbers, filtered_boards, :continue)
      end
    else
      last_winning_board(numbers, updated_boards, :continue)
    end
  end

  defp score_game(boards) do
    boards
    |> find_winning_board()
    |> List.flatten()
    |> Enum.reject(&(&1 == @marked_number))
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp find_winning_board(boards) do
    boards
    |> Enum.filter(&(closed_row?(&1) or closed_column?(&1)))
  end

  def mark_boards(number, boards) do
    boards
    |> Enum.map(&mark_board(&1, number))
  end

  defp mark_board(board, number) do
    board
    |> Enum.map(&mark_row(&1, number))
  end

  defp mark_row(row, number) do
    row
    |> Enum.map(fn item -> if item == number, do: @marked_number, else: item end)
  end

  defp game_ended?(boards) do
    boards
    |> Enum.any?(&(closed_row?(&1) or closed_column?(&1)))
  end

  def closed_row?(board) do
    board
    |> Enum.any?(fn row -> Enum.all?(row, fn item -> item == @marked_number end) end)
  end

  def closed_column?(board) do
    board
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> closed_row?()
  end
end
