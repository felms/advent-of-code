defmodule Day01 do
  @moduledoc """
  Dia 01 do Advento Of Code 2022
  """

  # ======= Problema 01 - Encontra o Elfo que carrega mais calorias
  def max_calories do

    # Lê o arquivo
    input = File.read!("./input.txt")

    # Separa os 'Elfos'
    elfs = String.split(input, "\n\n", trim: true)


    # Preenche a lista de somas
    sums = Enum.map(elfs, fn elf -> parseItem(elf)  end)

    # Retorna o numero de calorias carregadas 
    # pelo elfo que carrega mais 
    Enum.max(sums)

  end

  # Função a ser aplicada nos itens de cada Elfo
  defp parseItem(elf) do

    numbers = Enum.map(String.split(elf, "\n", trim: true), fn number -> String.to_integer(number) end)
    Enum.sum(numbers)

  end

end
