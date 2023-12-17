defmodule Day14 do
  @moduledoc """
  Dia 14 do Advent of Code 2023
  """

  def run(mode \\ :real_input) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

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

  def parse_input(input_string) do
    rows =
      input_string
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

  # - Problema 01
  def part_01(input) do
    input
    |> Enum.map(fn {{_r, c}, _v} -> c end)
    |> Enum.sort()
    |> Enum.uniq()
    |> Enum.map(fn column_number ->
      get_column(input, column_number)
      |> roll_rocks()
      |> calc_column_load()
    end)
    |> Enum.sum()
  end

  # - Calcula a carga total de uma coluna
  def calc_column_load(column) do
    len = column |> length()

    column
    |> Enum.map(fn {{r, _c}, v} -> if v != "O", do: 0, else: len - r end)
    |> Enum.sum()
  end

  # - Recupera uma coluna do grid
  def get_column(grid, column_number) do
    grid
    |> Enum.filter(fn {{_r, c}, _v} -> c == column_number end)
    |> Enum.sort()
  end

  # - Rola todas as rochas de uma coluna
  def roll_rocks(column), do: roll_rocks(column, 0)

  def roll_rocks(column, position) do
    if column |> length() <= position do
      column
    else
      {_k, v} = Enum.at(column, position)
      new_column = if v == "O", do: roll_rock(column, position), else: column
      roll_rocks(new_column, position + 1)
    end
  end

  # - Rola uma rocha para o norte do grid
  def roll_rock(column, rock_position) do
    if blocked?(column, rock_position) do
      column
    else
      {previous_k, previous_v} = Enum.at(column, rock_position - 1)
      {current_k, current_v} = Enum.at(column, rock_position)

      new_column =
        column
        |> List.replace_at(rock_position - 1, {previous_k, current_v})
        |> List.replace_at(rock_position, {current_k, previous_v})

      roll_rock(new_column, rock_position - 1)
    end
  end

  # - Testa se o caminho da rocha está bloqueado
  def blocked?(column, rock_position) do
    if rock_position - 1 < 0 do
      true
    else
      {_k, v} = Enum.at(column, rock_position - 1)
      if v != ".", do: true, else: false
    end
  end
end
