defmodule Day12 do
  @moduledoc """
  Dia 12 do Advent of Code 2022
  """

  Code.require_file("bfs.ex")
  Code.require_file("bfs_02.ex")

  def run(mode) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

    {time, result} = :timer.tc(&part_01/1, [input_file])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result.dist}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part_02/1, [input_file])

    IO.puts(
      "\n==Part 02== \n\nResult: #{result.dist}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  # ======= Problema 01 - Menor percurso partindo do ponto 'S'
  def part_01(input_file) do

    {start, goal, heightmap} = parse_input(input_file)

    BFS.bfs(start, goal, heightmap)

  end

  # ======= Problema 02 - Menor percurso partindo de
  # qualquer um dos pontos 'a'
  def part_02(input_file) do

    {start, goal, heightmap} = parse_input(input_file)

    BFS02.bfs(start, goal, heightmap)

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

    grid_indexes = for row <- 0..input_rows,  
						column <- 0..input_columns, do:
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

# --- Run
System.argv()
|> hd
|> String.to_atom
|> Day12.run()