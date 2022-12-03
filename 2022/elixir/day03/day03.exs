defmodule Day03 do
  @moduledoc """
  Dia 03 do Advent of Code 2022
  """

  # ======= Problema 01 - Priorizar os items
  def sum_of_priorities do

    File.read!("./input.txt")
    |> String.replace("\r", "") # Para evitar problemas no Windows
    |> String.split("\n", trim: true)
    |> Enum.map(fn rucksack -> String.split_at(rucksack, div(String.length(rucksack), 2)) end)
    |> Enum.map(fn rucksack -> repeated_items(rucksack) end)
    |> Enum.map(fn item -> item_priority(item) end)
    |> Enum.sum

  end

  defp repeated_items({first_rucksack, second_rucksack}) do

    String.graphemes(first_rucksack)
    |> Enum.filter(fn item -> String.contains?(second_rucksack, item) end)
    |> Enum.uniq
    |> hd

  end

  # ======= Problema 02 - Badges dos grupos
  def group_badges do

    File.read!("./input.txt")
    |> String.replace("\r", "") # Para evitar problemas no Windows
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(3)
    |> Enum.map(fn group -> intersection(group) |> item_priority end)
    |> Enum.sum

  end

  # ======= Utilitários
  
  # - Calcula a prioridade de cada item
  defp item_priority(item) do

    String.graphemes(" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    |> Enum.find_index(fn letter -> letter === item end)

  end

  # - Pega o item presente nas três listas
  defp intersection([rucksack0, rucksack1, rucksack2]) do

    String.graphemes(rucksack0)
    |> Enum.uniq
    |> Enum.filter(fn item -> 
      String.contains?(rucksack1, item) and String.contains?(rucksack2, item) 
    end)
    |> hd

  end

end

# ---- Run
IO.puts("Part 01")
Day03.sum_of_priorities |> IO.puts

IO.puts("\nPart 02")
Day03.group_badges |> IO.puts

