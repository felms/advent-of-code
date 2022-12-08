defmodule Day08 do
  @moduledoc """
  Dia 08 do Advent of Code 2022
  """

  # ======= Problema 01 - Quantas árvores são visiveis
  # de fora do grid
  def visible_trees do

    grid = parse_input()
    size = Map.keys(grid) |> length() |> Kernel.-(1)


    posittions = for n <- 0..size, 
						m <- 0..size, do: {n, m}

    posittions
    |> List.flatten
    |> Enum.filter(fn pos -> is_visible?(grid, size + 1, pos) end)
    |> length

  end

  # ======= Problema 02 - Maior pontuação cênica das
  # árvores do grid
  def highest_scenic_score do

    grid = parse_input()
    size = Map.keys(grid) |> length() |> Kernel.-(1)


    posittions = for n <- 0..size, 
						m <- 0..size, do: {n, m}

    posittions
    |> List.flatten
    |> Enum.reduce([], fn pos, acc -> 
      [ scenic_score(grid, pos) | acc]
    end)
    |> Enum.sort_by(fn item -> item["score"] end, :desc)
    |> hd
	|> then(&(&1["score"]))

  end

  # ======= Utilitários
  
  # - Lê o aquivo de entrada e monta a 
  # estrutura de dados que será trabalhada
  defp parse_input do

    {_ , map} = File.read!("./input.txt")
	|> String.replace("\r", "") # Para evitar problemas no Windows
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

  # - Testa se uma árvore é visivel de fora do grid
  # - Se está em uma das bordas é visivel
  defp is_visible?(_, _, {x, y}) when x === 0 or y === 0, do: true
  defp is_visible?(_, size, {x, y}) when x === size - 1 or y === size - 1, do: true

  # - Testa os outros casos
  defp is_visible?(grid, _size, {x, y}) do

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

  # - Calcula a "pontuação cênica" 
  # de uma árvore
  defp scenic_score(grid, {x, y}) do

    value = Map.get(grid, x) |> Map.get(y)

    # Mesma linha
    row = Map.get(grid, x)
    |> Map.to_list()
    |> List.keysort(0)

    looking_left = row
    |> Enum.filter(fn {k, _} -> k < y end)
    |> Enum.reverse
    |> Enum.reduce_while(0, fn {_, v}, acc -> 
      if v < value do
        {:cont, acc + 1}
      else
        {:halt, acc + 1}
      end
    end)

    looking_right = row
    |> Enum.filter(fn {k, _} -> k > y end)
    |> Enum.reduce_while(0, fn {_, v}, acc -> 
      if v < value do
        {:cont, acc + 1}
      else
        {:halt, acc + 1}
      end
    end)

    # Mesma coluna
    column = Map.to_list(grid)
    |> List.keysort(0)
    |> Enum.reduce([], fn {key, map}, acc ->
      value = Map.get(map, y)
      [{key, value} | acc]
    end)
    |> List.keysort(0)

    looking_up = column
    |> Enum.filter(fn {k, _} -> k < x end)
    |> Enum.reverse
    |> Enum.reduce_while(0, fn {_, v}, acc -> 
      if v < value do
        {:cont, acc + 1}
      else
        {:halt, acc + 1}
      end
    end)

    looking_down = column
    |> Enum.filter(fn {k, _} -> k > x end)
    |> Enum.reduce_while(0, fn {_, v}, acc -> 
      if v < value do
        {:cont, acc + 1}
      else
        {:halt, acc + 1}
      end
    end)

    score = looking_left * looking_up * looking_right * looking_down

    # Estrutura retornada
    %{"pos" => {x, y},
      "value" => value, 
      "score" => score}

  end

end

# --- Run
IO.puts("Part 01")
Day08.visible_trees
|> IO.puts

IO.puts("\nPart 02")
Day08.highest_scenic_score
|> IO.puts
