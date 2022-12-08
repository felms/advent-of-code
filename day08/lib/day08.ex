defmodule Day08 do
  @moduledoc """
  Dia 08 do Advent of Code 2022
  """

  # ======= Problema 01 - Quantas árvores são visiveis
  # de fora do grid
  def visible_trees do

    input = parse_input()
    size = Map.keys(input) |> length() |> Kernel.-(1)

    #is_visible?(input, size, {2, 3})

    posittions = for n <- 0..size, do:
                    for m <- 0..size, do: {n, m}

    posittions
    |> List.flatten()
    |> Enum.filter(fn pos -> is_visible?(input, size + 1, pos) end)
    |> length()

  end

  def parse_input do

    {_ , map} = File.read!("./input.txt")
    |> String.split("\n", trim: true)
    |> Enum.reduce({0, %{}}, fn line, acc ->
      {index, map} = acc

      new_map = Map.put(map, index, String.trim(line))
      {index + 1, new_map}
    end)

    map
    |> Enum.reduce(%{}, fn {key, value}, acc ->

      {_, entry} = String.graphemes(value)
      |> Enum.map(fn item -> String.to_integer(item) end)
      |> Enum.reduce({0, %{}}, fn number, acc ->
        {index, map} = acc
        new_map = Map.put(map, index, number)
        {index + 1, new_map}
      end)

      Map.put(acc, key, entry)

    end)
  end

  # - Se está em uma das bordas é visivel
  def is_visible?(_, _, {x, y}) when x === 0 or y === 0, do: true
  def is_visible?(_, size, {x, y}) when x === size - 1 or y === size - 1, do: true

  # - Testa os outros casos
  def is_visible?(grid, _size, {x, y}) do

    value = Map.get(grid, x) |> Map.get(y)

    # Mesma linha
    row = Map.get(grid, x)
    |> Map.to_list()
    |> List.keysort(0)

    is_visible_from_left = row
    |> Enum.filter(fn {k, _} -> k < y end)
    |> Enum.all?(fn {_, v} -> v < value end)

    is_visible_from_right = row
    |> Enum.filter(fn {k, _} -> k > y end)
    |> Enum.all?(fn {_, v} -> v < value end)

    # Mesma coluna
    column = Map.to_list(grid)
    |> List.keysort(0)
    |> Enum.reduce([], fn {key, map}, acc ->
      value = Map.get(map, y)
      [{key, value} | acc]
    end)
    |> List.keysort(0)

    is_visible_from_up = column
    |> Enum.filter(fn {k, _} -> k < x end)
    |> Enum.all?(fn {_, v} -> v < value end)

    is_visible_from_down = column
    |> Enum.filter(fn {k, _} -> k > x end)
    |> Enum.all?(fn {_, v} -> v < value end)

    is_visible_from_left or is_visible_from_right
    or is_visible_from_up or is_visible_from_down

  end

end
