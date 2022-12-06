defmodule Day06 do
  @moduledoc """
  Dia 06 do Advent of Code 2022
  """

  # ======= Problema 01 - Primeira posição com 4 caracteres unicos
  def first_unique do
    chunks = File.read!("./input.txt")
	|> String.replace("\r", "") # Para evitar problemas no Windows
    |> String.graphemes
    |> Enum.chunk_every(4, 1)

    first = chunks
    |> Enum.filter(fn list ->
      Enum.uniq(list) |> length === list |> length
    end)
    |> hd

    chunks
    |> Enum.find_index(fn item -> item === first end)
    |> Kernel.+(4)

  end

  # ======= Problema 02 - Primeira posição com 14 caracteres unicos
  def first_fourteen_unique do
    chunks = File.read!("./input.txt")
	|> String.replace("\r", "") # Para evitar problemas no Windows
    |> String.graphemes
    |> Enum.chunk_every(14, 1)

    first = chunks
    |> Enum.filter(fn list ->
      Enum.uniq(list) |> length === list |> length
    end)
    |> hd

    chunks
    |> Enum.find_index(fn item -> item === first end)
    |> Kernel.+(14)

  end

end

# --- Run
IO.puts("Part 01")
Day06.first_unique
|> IO.puts

IO.puts("\nPart 02")
Day06.first_fourteen_unique
|> IO.puts

