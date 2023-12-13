defmodule Day13 do
  @moduledoc """
  Dia 13 do Advent of Code 2023
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

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "\n==Part 02== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  # - Problema 01
  def part_01(input) do
    input
    |> Enum.reduce({0, 0}, fn pattern, {vertical_counts, horizontal_counts} ->
      new_v = vertical_counts + find_vertical_line_of_reflection(pattern)
      new_h = horizontal_counts + find_horizontal_line_of_reflection(pattern)
      {new_v, new_h}
    end)
    |> then(fn {v, h} -> h * 100 + v end)
  end

  # - Problema 02
  def part_02(input) do
    input
    |> Enum.reduce({0, 0}, fn pattern, {vertical_counts, horizontal_counts} ->
      {new_v, new_h} = fix_smudge(pattern)
      {new_v + vertical_counts, new_h + horizontal_counts}
    end)
    |> then(fn {v, h} -> h * 100 + v end)
  end

  def parse_input(input_string) do
    input_string
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_pattern/1)
  end

  def parse_pattern(pattern_string) do
    rows =
      pattern_string
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    grid_rows = rows |> length
    grid_columns = rows |> hd |> length

    grid_indexes =
      for row <- 0..(grid_rows - 1), do: for(column <- 0..(grid_columns - 1), do: {row, column})

    Enum.zip(
      List.flatten(grid_indexes),
      List.flatten(rows)
    )
    |> Enum.into(%{})
  end

  # - Retorna o resultado do cálculo da parte 01
  # com um ponto diferente do grid da parte 01
  def fix_smudge(grid) do
    points =
      grid
      |> Enum.map(fn {k, _v} -> k end)
      |> Enum.sort()

    fix_smudge(grid, points)
  end

  def fix_smudge(_grid, []), do: :error

  def fix_smudge(grid, [point | remaining_points]) do
    vertical_count = find_vertical_line_of_reflection(grid)
    horizontal_count = find_horizontal_line_of_reflection(grid)

    new_grid = flip_point(grid, point)

    new_v =
      case find_vertical_line_of_reflection(new_grid) do
        [a, b] -> if a != vertical_count, do: a, else: b
        x -> x
      end

    new_h =
      case find_horizontal_line_of_reflection(new_grid) do
        [a, b] -> if a != horizontal_count, do: a, else: b
        x -> x
      end

    cond do
      new_v == 0 and new_h == 0 -> fix_smudge(grid, remaining_points)
      new_v != 0 and new_v != vertical_count -> {new_v, 0}
      new_h != 0 and new_h != horizontal_count -> {0, new_h}
      true -> fix_smudge(grid, remaining_points)
    end
  end

  # - Muda o valor de um ponto do grid
  def flip_point(grid, point) do
    pt = if Map.get(grid, point) == ".", do: "#", else: "."

    Map.put(grid, point, pt)
  end

  # - Recupera uma linha específica do grid
  def get_row(grid, row_number) do
    grid
    |> Enum.filter(fn {{r, _c}, _v} -> r == row_number end)
    |> Enum.sort()
    |> Enum.map(fn {{_r, _c}, v} -> v end)
  end

  # - Recupera uma coluna específica do grid
  def get_column(grid, column_number) do
    grid
    |> Enum.filter(fn {{_r, c}, _v} -> c == column_number end)
    |> Enum.sort()
    |> Enum.map(fn {{_r, _c}, v} -> v end)
  end

  # - Encontra a linha de reflexão 
  # vertical no padrão
  def find_vertical_line_of_reflection(grid) do
    {min_col, max_col} =
      grid
      |> Enum.map(fn {{_r, c}, _v} -> c end)
      |> Enum.min_max()

    line_of_reflection =
      min_col..max_col
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.filter(fn [col_0, col_1] -> columns_match?(col_0, col_1, grid, max_col) end)

    case line_of_reflection do
      [[_a, b]] -> b
      [] -> 0
      [[_a, b], [_c, d]] -> [b, d]
    end
  end

  # - Testa se duas colunas são um ponto de reflexão
  # uma da outra
  def columns_match?(col_0, col_1, grid, max_col) do
    c_0 = get_column(grid, col_0)
    c_1 = get_column(grid, col_1)

    if col_0 == 0 or col_1 == max_col do
      equal?(c_0, c_1)
    else
      if equal?(c_0, c_1), do: columns_match?(col_0 - 1, col_1 + 1, grid, max_col), else: false
    end
  end

  # - Encontra a linha de reflexão 
  # horizontal no padrão
  def find_horizontal_line_of_reflection(grid) do
    {min_row, max_row} =
      grid
      |> Enum.map(fn {{r, _c}, _v} -> r end)
      |> Enum.min_max()

    line_of_reflection =
      min_row..max_row
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.filter(fn [row_0, row_1] -> rows_match?(row_0, row_1, grid, max_row) end)

    case line_of_reflection do
      [[_a, b]] -> b
      [] -> 0
      [[_a, b], [_c, d]] -> [b, d]
    end
  end

  # - Testa se duas colunas são um ponto de reflexão
  # uma da outra
  def rows_match?(row_0, row_1, grid, max_row) do
    r_0 = get_row(grid, row_0)
    r_1 = get_row(grid, row_1)

    if row_0 == 0 or row_1 == max_row do
      equal?(r_0, r_1)
    else
      if equal?(r_0, r_1), do: rows_match?(row_0 - 1, row_1 + 1, grid, max_row), else: false
    end
  end

  # - Testa se duas listas são iguais
  def equal?([], []), do: true
  def equal?([], _list_1), do: false
  def equal?(_list_0, []), do: false
  def equal?([x | _rem_0], [y | _rem_1]) when x != y, do: false
  def equal?([x | rem_0], [x | rem_1]), do: equal?(rem_0, rem_1)
end

# ---- Run
System.argv
|> hd
|> Day13.run