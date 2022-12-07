defmodule Day07 do
  @moduledoc """
  Dia 07 do Advent of Code 2022
  """

  # ======= Problema 01 - Soma dos diretorios com menos de 100000
  def sum_directories do
    File.read!("./input.txt")
    |> String.replace(~r/(\$\s)|(cd \.\.)|\r|ls/, "") # limpando o input
    |> String.split("cd",trim: true)
    |> Enum.map(fn item -> String.split(item, "\n", trim: true) end)
    |> Enum.reduce(%{}, fn [dir | items], acc -> Map.put(acc, dir, items) end)
  end

end
