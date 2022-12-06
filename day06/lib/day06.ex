defmodule Day06 do
  @moduledoc """
  Dia 06 do Advent of Code 2022
  """

  # ======= Problema 01 - Primira posição com 4 caracteres unicos
  def first_unique do
    chunks = File.read!("./input.txt")
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

end
