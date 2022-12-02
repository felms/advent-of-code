defmodule Day02 do
  @moduledoc """
  Dia 02 do Advent Of Code 2022
  """

  # ======= Problema 01 - Calcular os meus pontos no jogo de Pedra-Papel-Tesoura
  def total_score do

    # Lê o arquivo e separa as rodadas
    strategy_guide = File.read!("./input.txt")
		     |> String.replace("\r", "")
                     |> String.split("\n", trim: true) 
                     |> Enum.map(fn round -> String.split(round, " ", trim: true) end)

    # Calcula a soma dos pontos conseguidos
    Enum.map(strategy_guide, fn round -> calc_points(round) end) |> Enum.sum

  end

  # ======= Problema 02 - Calcular os meus pontos fazendo as jogadas do guia
  def score_using_strategy do

    # Lê o arquivo e separa as rodadas
    strategy_guide = File.read!("./input.txt")
		     |> String.replace("\r", "")
                     |> String.split("\n", trim: true) 
                     |> Enum.map(fn round -> String.split(round, " ", trim: true) end)

    # Mapeia o resultado desejado para jogadas
    rounds = Enum.map(strategy_guide, fn round -> 
      opponent = Enum.at(round, 0)
      outcome = Enum.at(round, 1)

      play = outcome_to_play(opponent, outcome)
      [opponent] ++ [play]

    end)

    # Calcula a soma dos pontos conseguidos
    Enum.map(rounds, fn round -> calc_points(round) end) |> Enum.sum

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
      player === "X" or player === "A" -> 1
      player === "Y" or player === "B" -> 2
      player === "Z" or player === "C" -> 3
    end
  end

  # - Calcula os pontos pela jogada
  defp calc_outcome(opponent, player) do
    cond do
      opponent === player -> 3
      opponent === "A" and player === "X" -> 3
      opponent === "B" and player === "Y" -> 3
      opponent === "C" and player === "Z" -> 3
      opponent === "A" and player === "Y" -> 6
      opponent === "B" and player === "Z" -> 6
      opponent === "C" and player === "X" -> 6
      opponent === "A" and player === "A" -> 3
      opponent === "B" and player === "B" -> 3
      opponent === "C" and player === "C" -> 3
      opponent === "A" and player === "B" -> 6
      opponent === "B" and player === "C" -> 6
      opponent === "C" and player === "A" -> 6
      true -> 0
    end
  end

  # - Mapeia o resultado desejado para jogadas
  defp outcome_to_play(opponent, outcome) do
    cond do 
      outcome === "Y" -> opponent
      opponent === "A" and outcome === "X" -> "C"
      opponent === "A" and outcome === "Z" -> "B"
      opponent === "B" and outcome === "X" -> "A"
      opponent === "B" and outcome === "Z" -> "C"
      opponent === "C" and outcome === "X" -> "B"
      opponent === "C" and outcome === "Z" -> "A"
    end
  end

end

# ---- Run
IO.puts("Part 01")
Day02.total_score |> IO.puts

IO.puts("\nPart 02")
Day02.score_using_strategy |> IO.puts

