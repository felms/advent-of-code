defmodule Day03 do
  @moduledoc """
  Dia 03 do Advent of Code 2023
  """

  def run(input_file) do

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> parse_input()

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "==Part 02== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  def parse_input(input) do
    points =
      input
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

  # - Problema 01
  def part_01(input) do
    max_r = input |> Enum.map(fn {r, _c} -> r end) |> Enum.max()
    max_c = input |> Enum.map(fn {_r, c} -> c end) |> Enum.max()

    symbols_locations =
      get_symbols_locations(input)
      |> Enum.map(fn {{r, c}, _symbol} -> {r, c} end)
      |> MapSet.new()

    get_numbers(input)
    |> Enum.map(fn {k, v} ->
      {
        k,
        v
        |> Enum.map(&get_neighbors/1)
        |> List.flatten()
        |> Enum.filter(fn {r, c} -> r >= 0 and r <= max_r and c >= 0 and c <= max_c end)
        |> MapSet.new()
      }
    end)
    |> Enum.reject(fn {_number, locations} -> MapSet.disjoint?(locations, symbols_locations) end)
    |> Enum.map(fn {k, _v} -> k end)
    |> Enum.sum()
  end

  # - Problema 02
  def part_02(input) do
    numbers_list = get_numbers(input)

    input
    |> get_symbols_locations()
    |> Enum.filter(fn {_k, v} -> v == "*" end)
    |> Enum.map(fn {k, _v} -> get_neighbor_numbers(k, numbers_list) end)
    |> Enum.filter(&(&1 |> length > 1))
    |> Enum.map(&(&1 |> Enum.product()))
    |> Enum.sum()
  end

  # - Retorna a lista com todos os números
  # vizinhos de um ponto
  def get_neighbor_numbers(point, numbers_list) do
    point_neighbors = get_neighbors(point)

    numbers_list
    |> Enum.filter(fn {_number, locations} ->
      locations |> Enum.any?(&(&1 in point_neighbors))
    end)
    |> Enum.map(fn {number, _locations} -> number end)
  end

  # - Retorna a localização dos símbolos no grid
  def get_symbols_locations(input), do: input |> Enum.reject(fn {_k, v} -> v =~ ~r/\d|\./ end)

  # - Retorna os vizinhos de um ponto
  def get_neighbors({r, c}) do
    [
      {r - 1, c},
      {r + 1, c},
      {r, c - 1},
      {r, c + 1},
      {r - 1, c - 1},
      {r - 1, c + 1},
      {r + 1, c + 1},
      {r + 1, c - 1}
    ]
  end

  # - Percorre todas as linhas e procura os números em cada uma delas
  def get_numbers(input) do
    number_of_rows = input |> Enum.map(fn {{r, _y}, _v} -> r end) |> Enum.max()
    number_of_columns = input |> Enum.map(fn {{_r, c}, _v} -> c end) |> Enum.max()

    Enum.reduce(0..number_of_rows, [], fn current_row, acc ->
      row = input |> Enum.filter(fn {{r, _c}, _v} -> r == current_row end) |> Map.new()
      acc ++ get_numbers_from_row(0, number_of_columns, current_row, row, "", [], [])
    end)
    |> Enum.filter(fn {k, _v} -> k =~ ~r/\d+/ end)
    |> Enum.map(fn {k, v} -> {String.to_integer(k), v} end)
  end

  # - Recupera todos os números de uma linha
  # e as posições ocupadas por cada um deles
  def get_numbers_from_row(current_index, length, _r, _row, current_number, positions, numbers)
      when current_index > length do
    updated_numbers = numbers ++ [{current_number, positions}]
    updated_numbers
  end

  def get_numbers_from_row(current_index, length, r, row, current_number, positions, numbers) do
    current_value = row[{r, current_index}]

    if current_value =~ ~r/\d/ do
      updated_number = current_number <> current_value
      updated_positions = positions ++ [{r, current_index}]

      get_numbers_from_row(
        current_index + 1,
        length,
        r,
        row,
        updated_number,
        updated_positions,
        numbers
      )
    else
      updated_numbers = numbers ++ [{current_number, positions}]
      get_numbers_from_row(current_index + 1, length, r, row, "", [], updated_numbers)
    end
  end
end

# ---- Run
System.argv
|> hd
|> Day03.run