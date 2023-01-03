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

    Utils.state_hash(initial_grid, [{0, 1}, {1, 0}, {1, 1}, {1, 2}, {2, 1}], jets)

  end

end
