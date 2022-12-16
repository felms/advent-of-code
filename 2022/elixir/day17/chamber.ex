defmodule Chamber do
  # - Simula a queda de uma rocha
  def drop_rock(rock, grid, jets) do
    positioned_rock = position_rock(rock, grid)
    move = :lateral

    drop_rock(positioned_rock, jets, grid, move)
  end

  defp drop_rock(rock, jets, grid, move) do
    {move_result, new_move, new_jets} = move_rock(rock, move, jets, grid)
    {status, new_rock} = move_result

    if status === :stopped and move === :vertical do
      new_grid = MapSet.union(grid, MapSet.new(rock))
      {new_grid, jets}
    else
      drop_rock(new_rock, new_jets, grid, new_move)
    end
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
  defp move_rock(rock, :vertical, jets, grid), do: {vertical_move(rock, grid), :lateral, jets}

  defp move_rock(rock, :lateral, jets, grid) do
    {direction, remaining_jets} = List.pop_at(jets, 0)
    {lateral_move(rock, direction, grid), :vertical, remaining_jets ++ [direction]}
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
  defp lateral_move(rock, "<", grid), do: left_move(rock, grid)
  defp lateral_move(rock, ">", grid), do: right_move(rock, grid)

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
