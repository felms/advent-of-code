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
      Enum.reduce(1..number_of_rocks, {rocks_list, initial_grid, jets}, fn _, acc ->
        {curr_rocks_list, curr_grid, curr_jets} = acc

        {curr_rock, remaining_rocks} = List.pop_at(curr_rocks_list, 0)
        new_rocks_list = List.insert_at(remaining_rocks, -1, curr_rock)

        {_, new_grid, _, new_jets} = Chamber.drop_rock(curr_rock, curr_grid, curr_jets)

        {new_rocks_list, new_grid, new_jets}
      end)

    Utils.grid_highest_row(res_grid)
  end

  def part_02(input_file) do
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

    #Utils.state_hash(initial_grid, [{0, 1}, {1, 0}, {1, 1}, {1, 2}, {2, 1}], jets)

    {res_grid, cached_height} = cached_simulation(initial_grid, rocks_list, jets, Map.new(), 0, 0, 2022)

    IO.inspect({Utils.grid_highest_row(res_grid), cached_height})
  end

  def cached_simulation(grid, rocks_list, jets, cache, cached_height, current_index, max_index)
  def cached_simulation(grid, _, _, _, cached_height, current_index, max_index) when current_index === max_index, do: {grid, cached_height}
  def cached_simulation(grid, rocks_list, jets, cache, cached_height, current_index, max_index) do

    {curr_rock, remaining_rocks} = List.pop_at(rocks_list, 0)
    new_rocks_list = List.insert_at(remaining_rocks, -1, curr_rock)
    current_height = Utils.grid_highest_row(grid)

    current_hash = Utils.state_hash(grid, curr_rock, jets)
    {new_height, new_index, updated_cache} = check_cache(cache, current_hash, current_height, current_index, max_index)

    new_cache = Map.put(updated_cache, current_hash, current_height)

    {_, new_grid, _, new_jets} = Chamber.drop_rock(curr_rock, grid, jets)

    cached_simulation(new_grid, new_rocks_list, new_jets, new_cache, new_height, new_index + 1, max_index)

  end

  defp check_cache(map, hash, height, current_index, max_index) do
    if Map.has_key?(map, hash) do
      rem_value = rem(max_index, current_index)
      reps = div((max_index - rem_value), current_index)
      cached_height = Map.get(map, hash)
      new_height = (cached_height * 2) * (reps - 1)
      new_index = current_index * reps
      IO.puts("Encontrado na iteração #{current_index}")
      IO.inspect({rem_value, reps, cached_height, new_height, current_index, new_index})
      #{height, current_index, map}
      {new_height, new_index, Map.new()}
    else
      {height, current_index, map}
    end
  end
end
