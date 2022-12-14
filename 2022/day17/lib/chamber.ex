defmodule Chamber do
  # - Simula a queda de uma rocha
  def drop_rock(rock, grid, jets) do
    rock_pos = position_rock(rock, grid)
    move = :lateral

    Enum.reduce_while(0..100, {rock_pos, grid, move, jets}, fn _, acc ->
      {curr_rock, curr_grid, curr_move, curr_jets} = acc

      {move_result, new_move, new_jets} = move_rock(curr_rock, curr_move, curr_jets, grid)
      {status, new_rock} = move_result

      if status === :stopped and curr_move === :vertical do
        new_grid = MapSet.union(grid, MapSet.new(curr_rock))
        {:halt, {curr_rock, new_grid, curr_move, curr_jets}}
      else
        {:cont, {new_rock, curr_grid, new_move, new_jets}}
      end
    end)
  end

  # - Posiciona uma rocha no ponto inicial
  defp position_rock(rock, grid) do
    highest_row = Utils.grid_highest_row(grid)

    new_row = highest_row + 4
    new_col = 2

    rock
    |> Enum.map(fn {row, col} -> {row + new_row, col + new_col} end)
  end

  # - Move a rocha uma posição
  # para o lado ou para baixo
  defp move_rock(rock, move, jets, grid) do
    if move === :vertical do
      move_result = vertical_move(rock, grid)
      new_move = :lateral
      {move_result, new_move, jets}
    else
      {direction, remaining_jets} = List.pop_at(jets, 0)
      new_jets = remaining_jets ++ [direction]
      new_move = :vertical
      move_result = lateral_move(rock, direction, grid)
      {move_result, new_move, new_jets}
    end
  end

  # - Executa o movimento vertical
  defp vertical_move(rock, grid) do
    new_rock = rock |> Enum.map(fn {row, col} -> {row - 1, col} end)
    cant_move = Enum.any?(new_rock, fn point -> MapSet.member?(grid, point) end)

    if cant_move do
      {:stopped, rock}
    else
      {:moved, new_rock}
    end
  end

  # - Executa o movimento horizontal
  defp lateral_move(rock, direction, grid) do
    cond do
      direction === "<" ->
        left_move(rock, grid)

      direction === ">" ->
        right_move(rock, grid)

      true ->
        raise("Error!\nReceived: " <> direction)
    end
  end

  defp left_move(rock, grid) do
    new_rock = rock |> Enum.map(fn {row, column} -> {row, column - 1} end)

    cant_move =
      Enum.any?(new_rock, fn point ->
        MapSet.member?(grid, point) or point |> elem(1) < 0
      end)

    if cant_move do
      {:stopped, rock}
    else
      {:moved, new_rock}
    end
  end

  defp right_move(rock, grid) do
    new_rock = rock |> Enum.map(fn {row, column} -> {row, column + 1} end)

    cant_move =
      Enum.any?(new_rock, fn point ->
        MapSet.member?(grid, point) or point |> elem(1) > 6
      end)

    if cant_move do
      {:stopped, rock}
    else
      {:moved, new_rock}
    end
  end
end
