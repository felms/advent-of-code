defmodule Day12 do
  @moduledoc """
  Dia 12 do Advent of Code 2022
  """

  # ======= Problema 01 - Nivel de 'monkey business'
  def part_01(input_file) do

    {start, goal, heightmap} = parse_input(input_file)

    path = BFS.bfs(start, goal, heightmap)

    path

  end

  # ======= Utilitários
  # - Faz o parse do input e gera a estrutura de dados inicial
  defp parse_input(input_file) do

    input = File.read!(input_file)
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.graphemes(line) end)

    input_rows = input |> length
    input_columns = input |> hd |> length

    input_rows = input_rows - 1
    input_columns = input_columns - 1

    grid_indexes = for row <- 0..input_rows, do:
                    for column <- 0..input_columns, do:
                      {row, column}

    index_item = Enum.zip(List.flatten(grid_indexes), List.flatten(input))
                 |> Enum.into(%{})

    {start_position, _} = Enum.filter(index_item, fn {_k, v} -> v === "S" end) |> hd
    {end_position, _} = Enum.filter(index_item, fn {_k, v} -> v === "E" end) |> hd


    letter_values = "abcdefghijklmnopqrstuvwxyz"
                    |> String.graphemes
                    |> Enum.with_index
                    |> Enum.into(%{})

    heightmap = Enum.reduce(index_item, %{}, fn {k, v}, acc ->

      cond do
        v === "S" -> Map.put(acc, k, 0)
        v === "E" -> Map.put(acc, k, 25)
        true ->
          value = Map.get(letter_values, v)
          Map.put(acc, k, value)
      end
    end)

    {start_position, end_position, heightmap}

  end

end
