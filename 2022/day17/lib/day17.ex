defmodule Day17 do
  @moduledoc """
  Dia 17 do Advent of Code 2022
  """
  # Quantidade de tipos de rochas
  @types_of_rocks 5

  # Os cinco modelos de rochas que caêm
  @rocks_list [
    # horizontal
    [{0, 0}, {0, 1}, {0, 2}, {0, 3}],
    # cruz
    [{0, 1}, {1, 0}, {1, 1}, {1, 2}, {2, 1}],
    # esquina
    [{0, 0}, {0, 1}, {0, 2}, {1, 2}, {2, 2}],
    # vertical
    [{0, 0}, {1, 0}, {2, 0}, {3, 0}],
    # quadrado
    [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  ]

  # Estado inicial
  @initial_grid MapSet.new([{0, 0}, {0, 1}, {0, 2}, {0, 3}, {0, 4}, {0, 5}, {0, 6}])

  # Número de rochas
  @number_of_rocks 2022

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

    File.read!(input_file)
    # Para evitar problemas no Windows
    |> String.replace("\r", "")
    |> String.trim()
    |> String.graphemes()
    |> run_simulation(0, @number_of_rocks, @rocks_list, @initial_grid)
    |> Utils.grid_highest_row()
  end

  defp run_simulation(_jets, rocks, rocks, _rocks_list, grid), do: grid

  defp run_simulation(jets, current_rock_number, number_of_rocks, rocks_list, grid) do
    pos = rem(current_rock_number, @types_of_rocks)

    curr_rock = Enum.at(rocks_list, pos)
    {_, new_grid, _, new_jets} = Chamber.drop_rock(curr_rock, grid, jets)

    run_simulation(new_jets, current_rock_number + 1, number_of_rocks, rocks_list, new_grid)
  end

  def part_02(input_file) do
    # Lê o arquivo de entrada e armazena
    jets =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.trim()
      |> String.graphemes()

    # Utils.state_hash(initial_grid, [{0, 1}, {1, 0}, {1, 1}, {1, 2}, {2, 1}], jets)

    {res_grid, cached_height} =
      cached_simulation(@initial_grid, @rocks_list, jets, Map.new(), 0, 0, @number_of_rocks)

    IO.inspect({Utils.grid_highest_row(res_grid), cached_height})
  end

  def cached_simulation(grid, rocks_list, jets, cache, cached_height, current_index, max_index)

  def cached_simulation(grid, _, _, _, cached_height, current_index, max_index)
      when current_index === max_index,
      do: {grid, cached_height}

  def cached_simulation(grid, rocks_list, jets, cache, cached_height, current_index, max_index) do
    {curr_rock, remaining_rocks} = List.pop_at(rocks_list, 0)
    new_rocks_list = List.insert_at(remaining_rocks, -1, curr_rock)
    current_height = Utils.grid_highest_row(grid)

    current_hash = Utils.state_hash(grid, curr_rock, jets)

    {new_height, new_index, updated_cache} =
      check_cache(cache, current_hash, current_height, current_index, max_index)

    new_cache = Map.put(updated_cache, current_hash, current_height)

    {_, new_grid, _, new_jets} = Chamber.drop_rock(curr_rock, grid, jets)

    cached_simulation(
      new_grid,
      new_rocks_list,
      new_jets,
      new_cache,
      new_height,
      new_index + 1,
      max_index
    )
  end

  defp check_cache(map, hash, height, current_index, max_index) do
    if Map.has_key?(map, hash) do
      rem_value = rem(max_index, current_index)
      reps = div(max_index - rem_value, current_index)
      cached_height = Map.get(map, hash)
      new_height = cached_height * 2 * (reps - 1)
      new_index = current_index * reps
      IO.puts("Encontrado na iteração #{current_index}")
      IO.inspect({rem_value, reps, cached_height, new_height, current_index, new_index})
      # {height, current_index, map}
      {new_height, new_index, Map.new()}
    else
      {height, current_index, map}
    end
  end
end
