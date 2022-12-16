defmodule Day17 do
  @moduledoc """
  Dia 17 do Advent of Code 2022
  """
  
  Code.require_file("utils.ex")
  Code.require_file("chamber.ex")
  
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
  @number_of_rocks_p1 2022

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
    |> run_simulation(0, @number_of_rocks_p1, @rocks_list, @initial_grid)
    |> Utils.grid_highest_row()
  end

  defp run_simulation(_jets, rocks, rocks, _rocks_list, grid), do: grid

  defp run_simulation(jets, current_rock_number, number_of_rocks, rocks_list, grid) do
    pos = rem(current_rock_number, @types_of_rocks)

    curr_rock = Enum.at(rocks_list, pos)
    {new_grid, new_jets} = Chamber.drop_rock(curr_rock, grid, jets)

    run_simulation(new_jets, current_rock_number + 1, number_of_rocks, rocks_list, new_grid)
  end

  # ======= Problema 02 - Contar a altura do grid
  # após 1_000_000_000_000 rochas caírem
  def part_02(input_file) do
  end

end

# --- Run
System.argv()
|> hd
|> Day17.run()