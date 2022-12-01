defmodule Day01 do
  @moduledoc """
  Dia 01 do Advento Of Code 2022
  """

  # ======= Problema 01 - Encontrar o Elfo que carrega mais calorias
  def max_calories do

    # Lê o arquivo e separa os elfos
    elves = File.read!("./input.txt") |> String.replace("\r", "") |> String.split("\n\n", trim: true)

    # Preenche a lista de somas
    sums = Enum.map(elves, fn elf -> parse_item(elf)  end)

    # Retorna o numero de calorias carregadas 
    # pelo elfo que carrega mais 
    Enum.max(sums)

  end

  # ======= Problema 02 - Encontrar os três Elfos que carregam mais calorias
  def top_three_elves do

    # Lê o arquivo e separa os elfos
    elves = File.read!("./input.txt") |> String.replace("\r", "") |> String.split("\n\n", trim: true)

    # Preenche a lista de somas com os items ordenados
    sums = Enum.sort(
      Enum.map(elves, fn elf -> parse_item(elf)  end),
      :desc
    )

    # Retorna a soma do top 3
    Enum.slice(sums, 0..2) |> Enum.sum

  end
  

  # ======= Utilitário - Calcula a soma dos itens de cada Elfo
  defp parse_item(elf) do

    Enum.map(String.split(elf, "\n", trim: true), fn number -> String.to_integer(number) end) 
    |> Enum.sum

  end

end

# ---- Run
IO.puts("Part 01")
Day01.max_calories |> IO.puts

IO.puts("\nPart 02")
Day01.top_three_elves |> IO.puts