defmodule Day11 do
  @moduledoc """
  Dia 11 do Advent of Code 2023
  """

  def run(input_file) do

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> parse_input()

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  # - Problema 01
  def part_01(input) do
    input
    |> expand()
    |> assign_numbers_to_galaxies()
    |> generate_pairs([])
    |> Enum.map(fn {{coord_1, _v1}, {coord_2, _v2}} -> manhattan_distance(coord_1, coord_2) end)
    |> Enum.sum()
  end

  def parse_input(input_string) do
    points =
      input_string
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    grid_rows = points |> length
    grid_columns = points |> hd |> length

    grid_indexes =
      for row <- 0..(grid_rows - 1), do: for(column <- 0..(grid_columns - 1), do: {row, column})

    Enum.zip(
      List.flatten(grid_indexes),
      List.flatten(points)
    )
    |> Enum.into(%{})
  end

  # - Gera os pares de itens
  def generate_pairs([], pairs_list), do: pairs_list

  def generate_pairs([head | tail], pairs_list) do
    generated_pairs =
      tail
      |> Enum.reduce([], fn tuple, acc ->
        [{head, tuple} | acc]
      end)

    generate_pairs(tail, generated_pairs ++ pairs_list)
  end

  # - Troca os '#' por números, dando um número único para
  # cada tupla.
  def assign_numbers_to_galaxies(grid) do
    grid
    |> Enum.sort()
    |> Enum.with_index(1)
    |> Enum.map(fn {{coord, _v}, index} -> {coord, index} end)
  end

  # - Expande uma "imagem" dobrando as linhas e/ou colunas vazias
  def expand(image) do
    number_of_rows = image |> Enum.map(fn {{r, _c}, _v} -> r end) |> Enum.max()
    number_of_columns = image |> Enum.map(fn {{_r, c}, _v} -> c end) |> Enum.max()

    image
    |> Map.to_list()
    |> Enum.filter(fn {_coord, v} -> v == "#" end)
    |> expand_rows(0, number_of_rows, number_of_columns)
    |> expand_columns(0, number_of_columns, number_of_rows)
  end

  # - Expande as linhas da "imagem" dobrando as linhas vazias
  def expand_rows(grid, current_row, number_of_rows, _number_of_columns)
      when current_row > number_of_rows,
      do: grid

  def expand_rows(grid, current_row, number_of_rows, number_of_columns) do
    row = grid |> Enum.filter(fn {{r, _c}, _v} -> r == current_row end)

    if row == [] do
      new_grid =
        grid
        |> Enum.map(fn {{r, c}, v} ->
          if r >= current_row, do: {{r + 1, c}, v}, else: {{r, c}, v}
        end)

      expand_rows(new_grid, current_row + 2, number_of_rows + 1, number_of_columns)
    else
      expand_rows(grid, current_row + 1, number_of_rows, number_of_columns)
    end
  end

  # - Expande as colunas da "imagem" dobrando as columnas vazias.
  def expand_columns(grid, current_column, number_of_columns, _number_of_rows)
      when current_column > number_of_columns,
      do: grid

  def expand_columns(grid, current_column, number_of_columns, number_of_rows) do
    column = grid |> Enum.filter(fn {{_r, c}, _v} -> c == current_column end)

    if column == [] do
      new_grid =
        grid
        |> Enum.map(fn {{r, c}, v} ->
          if c >= current_column, do: {{r, c + 1}, v}, else: {{r, c}, v}
        end)

      expand_columns(new_grid, current_column + 2, number_of_columns + 1, number_of_rows)
    else
      expand_columns(grid, current_column + 1, number_of_columns, number_of_rows)
    end
  end

  # - Distancia entre dois pontos
  def manhattan_distance(point_a, point_b) do
    {x_1, y_1} = point_a
    {x_2, y_2} = point_b

    abs(x_1 - x_2) + abs(y_1 - y_2)
  end
end

# ---- Run
System.argv
|> hd
|> Day11.run