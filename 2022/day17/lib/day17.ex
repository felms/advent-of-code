defmodule Day17 do
  @moduledoc """
  Dia 17 do Advent of Code 2022
  """

  def run(input_file \\ "sample_input.txt") do
    {time, result} = :timer.tc(&part_01/1, [input_file])

    IO.puts(
      "==Part 01== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  # ======= Problema 01 - Contar a altura do grid
  # após 2022 rochas caírem
  defp part_01(input_file) do
    # Lê o arquivo de entrada e armazena
    jets =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.trim()
      |> String.graphemes()

    # Os cinco modelos de rochas que caêm 
    rocks_list = [
      [{0, 0}, {0, 1}, {0, 2}, {0, 3}],           # horizontal
      [{0, 1}, {1, 0}, {1, 1}, {1, 2}, {2, 1}],   # cruz
      [{0, 0}, {0, 1}, {0, 2}, {1, 2}, {2, 2}],   # esquina
      [{0, 0}, {1, 0}, {2, 0}, {3, 0}],           # vertical
      [{0, 0}, {0, 1}, {1, 0}, {1, 1}]            # quadrado
    ]

    # Estado inicial 
    initial_grid = MapSet.new([{0, 0}, {0, 1}, {0, 2}, {0, 3}, {0, 4}, {0, 5}, {0, 6}])

    # Número de rochas
    number_of_rocks = 2022

    # Roda a simulçao
    {_, res_grid, _} =
      Enum.reduce(0..(number_of_rocks - 1), {rocks_list, initial_grid, jets}, fn _, acc ->
        {curr_rocks_list, curr_grid, curr_jets} = acc

        {curr_rock, remaining_rocks} = List.pop_at(curr_rocks_list, 0)
        new_rocks_list = List.insert_at(remaining_rocks, -1, curr_rock)

        {_, new_grid, _, new_jets} = drop_rock(curr_rock, curr_grid, curr_jets)

        {new_rocks_list, new_grid, new_jets}
      end)

    grid_highest_row(res_grid)
  end

  # - Posiciona uma rocha no ponto inicial
  defp position_rock(rock, grid) do
    highest_row = grid_highest_row(grid)

    new_row = highest_row + 4
    new_col = 2

    rock
    |> Enum.map(fn {row, col} -> {row + new_row, col + new_col} end)
  end

  # - Pega o ponto mais alto do grid
  defp grid_highest_row(grid) do
    grid
    |> MapSet.to_list()
    |> List.keysort(0, :desc)
    |> hd()
    |> elem(0)
  end

  # - Simula a queda de uma rocha
  defp drop_rock(rock, grid, jets) do
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
