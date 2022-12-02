defmodule Day02 do
  @moduledoc """
  Dia 02 do Advent Of Code 2022
  """

  # ======= Problema 01 - Calcular os meus pontos no jogo de Pedra-Papel-Tesoura
  def total_score do

    # Lê o arquivo e separa as rodadas
    strategy_guide = File.read!("./input.txt") 
                     |> String.split("\n", trim: true) 
                     |> Enum.map(fn round -> String.split(round, " ", trim: true) end)

    # Calcula a soma dos pontos conseguidos
    Enum.map(strategy_guide, fn round -> calc_points(round) end) |> Enum.sum

  end

  # ======= Utilitários 
  # - Calcula os pontos por rodada
  defp calc_points(round) do
    opponent = Enum.at(round, 0)
    player = Enum.at(round, 1)

    points_by_selection(player) + calc_outcome(opponent, player)

  end

  # - Calcula os pontos pela seleção
  defp points_by_selection(player) do
    cond do 
      player === "X" -> 1
      player === "Y" -> 2
      player === "Z" -> 3
    end
  end

  # - Calcula os pontos pela jogada
  defp calc_outcome(opponent, player) do
    cond do
      opponent === "A" and player === "X" -> 3
      opponent === "B" and player === "Y" -> 3
      opponent === "C" and player === "Z" -> 3
      opponent === "A" and player === "Y" -> 6
      opponent === "B" and player === "Z" -> 6
      opponent === "C" and player === "X" -> 6
      true -> 0
    end
  end


end
