defmodule Day14 do
  @moduledoc """
  Dia 14 do Advent of Code 2023
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
      |> roll_rocks_north()
      |> calc_column_load()
    end)
    |> Enum.sum()
  end

  # - Calcula a carga total de um grid 
  def calc_total_load(grid) do
    grid
    |> Enum.map(fn {{_r, c}, _v} -> c end)
    |> Enum.sort()
    |> Enum.uniq()
    |> Enum.map(fn column_number ->
      get_column(grid, column_number)
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

  # - Recupera uma linha do grid
  def get_row(grid, row_number) do
    grid
    |> Enum.filter(fn {{r, _c}, _v} -> r == row_number end)
    |> Enum.sort()
  end

  # - Recupera uma coluna do grid
  def get_column(grid, column_number) do
    grid
    |> Enum.filter(fn {{_r, c}, _v} -> c == column_number end)
    |> Enum.sort()
  end

  # - Executa um número específico de ciclos
  def execute_cycles(grid, number_of_cycles) do
    1..number_of_cycles
    |> Enum.reduce(grid, fn cycle_number, acc -> 
      new_grid = execute_cycle(acc) 
      load = new_grid |> calc_total_load
      IO.puts("Cycle: #{cycle_number} Load: #{load}")
      new_grid
    end)
  end

  # - Executa um ciclo deslocando as rochas nas 4 direções
  def execute_cycle(grid) do
    grid
    |> execute_north()
    |> execute_west()
    |> execute_south()
    |> execute_east()
  end

  # - Executa a "parte norte" do ciclo
  def execute_north(grid) do
    grid
    |> Enum.map(fn {{_r, c}, _v} -> c end)
    |> Enum.sort()
    |> Enum.uniq()
    |> Enum.map(fn column_number ->
      get_column(grid, column_number)
      |> roll_rocks_north()
    end)
    |> List.flatten()
    |> Map.new()
  end

  # - Executa a "parte sul" do ciclo
  def execute_south(grid) do
    grid
    |> Enum.map(fn {{_r, c}, _v} -> c end)
    |> Enum.sort()
    |> Enum.uniq()
    |> Enum.map(fn column_number ->
      get_column(grid, column_number)
      |> roll_rocks_south()
    end)
    |> List.flatten()
    |> Map.new()
  end

  # - Executa a "parte leste" do ciclo
  def execute_east(grid) do
    grid
    |> Enum.map(fn {{r, _c}, _v} -> r end)
    |> Enum.sort()
    |> Enum.uniq()
    |> Enum.map(fn row_number ->
      get_row(grid, row_number)
      |> roll_rocks_east()
    end)
    |> List.flatten()
    |> Map.new()
  end

  # - Executa a "parte leste" do ciclo
  def execute_west(grid) do
    grid
    |> Enum.map(fn {{r, _c}, _v} -> r end)
    |> Enum.sort()
    |> Enum.uniq()
    |> Enum.map(fn row_number ->
      get_row(grid, row_number)
      |> roll_rocks_west()
    end)
    |> List.flatten()
    |> Map.new()
  end

  ## -- NORTE --
  #
  # - Rola todas as rochas de uma coluna para o norte
  def roll_rocks_north(column), do: roll_rocks_north(column, 0)

  def roll_rocks_north(column, position) do
    if column |> length() <= position do
      column
    else
      {_k, v} = Enum.at(column, position)
      new_column = if v == "O", do: roll_rock_north(column, position), else: column
      roll_rocks_north(new_column, position + 1)
    end
  end

  # - Rola uma rocha para o norte do grid
  def roll_rock_north(column, rock_position) do
    if blocked_north?(column, rock_position) do
      column
    else
      {previous_k, previous_v} = Enum.at(column, rock_position - 1)
      {current_k, current_v} = Enum.at(column, rock_position)

      new_column =
        column
        |> List.replace_at(rock_position - 1, {previous_k, current_v})
        |> List.replace_at(rock_position, {current_k, previous_v})

      roll_rock_north(new_column, rock_position - 1)
    end
  end

  # - Testa se o caminho da rocha está bloqueado ao norte
  def blocked_north?(column, rock_position) do
    if rock_position - 1 < 0 do
      true
    else
      {_k, v} = Enum.at(column, rock_position - 1)
      if v != ".", do: true, else: false
    end
  end

  ## -- SUL --
  #
  # - Rola todas as rochas de uma coluna para o sul
  def roll_rocks_south(column), do: roll_rocks_south(column, (column |> length()) - 1)

  def roll_rocks_south(column, position) do
    if position < 0 do
      column
    else
      {_k, v} = Enum.at(column, position)
      new_column = if v == "O", do: roll_rock_south(column, position), else: column
      roll_rocks_south(new_column, position - 1)
    end
  end

  # - Rola uma rocha para o sul do grid
  def roll_rock_south(column, rock_position) do
    if blocked_south?(column, rock_position) do
      column
    else
      {next_k, next_v} = Enum.at(column, rock_position + 1)
      {current_k, current_v} = Enum.at(column, rock_position)

      new_column =
        column
        |> List.replace_at(rock_position + 1, {next_k, current_v})
        |> List.replace_at(rock_position, {current_k, next_v})

      roll_rock_south(new_column, rock_position + 1)
    end
  end

  # - Testa se o caminho da rocha está bloqueado ao sul
  def blocked_south?(column, rock_position) do
    if rock_position + 1 >= column |> length() do
      true
    else
      {_k, v} = Enum.at(column, rock_position + 1)
      if v != ".", do: true, else: false
    end
  end

  ## -- LESTE --
  #
  # - Rola todas as rochas de uma linha para o leste
  def roll_rocks_east(row), do: roll_rocks_east(row, (row |> length()) - 1)

  def roll_rocks_east(row, position) do
    if position < 0 do
      row
    else
      {_k, v} = Enum.at(row, position)
      new_row = if v == "O", do: roll_rock_east(row, position), else: row
      roll_rocks_east(new_row, position - 1)
    end
  end

  # - Rola uma rocha para o leste do grid
  def roll_rock_east(row, rock_position) do
    if blocked_east?(row, rock_position) do
      row
    else
      {next_k, next_v} = Enum.at(row, rock_position + 1)
      {current_k, current_v} = Enum.at(row, rock_position)

      new_row =
        row
        |> List.replace_at(rock_position + 1, {next_k, current_v})
        |> List.replace_at(rock_position, {current_k, next_v})

      roll_rock_east(new_row, rock_position + 1)
    end
  end

  # - Testa se o caminho da rocha está bloqueado ao leste
  def blocked_east?(row, rock_position) do
    if rock_position + 1 >= row |> length() do
      true
    else
      {_k, v} = Enum.at(row, rock_position + 1)
      if v != ".", do: true, else: false
    end
  end

  ## -- OESTE --
  #
  # - Rola todas as rochas de uma linha para o oeste
  def roll_rocks_west(row), do: roll_rocks_west(row, 0)

  def roll_rocks_west(row, position) do
    if row |> length() <= position do
      row
    else
      {_k, v} = Enum.at(row, position)
      new_row = if v == "O", do: roll_rock_west(row, position), else: row
      roll_rocks_west(new_row, position + 1)
    end
  end

  # - Rola uma rocha para o oeste do grid
  def roll_rock_west(row, rock_position) do
    if blocked_west?(row, rock_position) do
      row
    else
      {previous_k, previous_v} = Enum.at(row, rock_position - 1)
      {current_k, current_v} = Enum.at(row, rock_position)

      new_row =
        row
        |> List.replace_at(rock_position - 1, {previous_k, current_v})
        |> List.replace_at(rock_position, {current_k, previous_v})

      roll_rock_west(new_row, rock_position - 1)
    end
  end

  # - Testa se o caminho da rocha está bloqueado ao leste
  def blocked_west?(row, rock_position) do
    if rock_position - 1 < 0 do
      true
    else
      {_k, v} = Enum.at(row, rock_position - 1)
      if v != ".", do: true, else: false
    end
  end
end

# ---- Run
System.argv
|> hd
|> Day14.run
