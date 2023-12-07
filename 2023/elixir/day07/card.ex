defmodule Card do
  @moduledoc """
  Define uma Carta do jogo e funções auxiliares
  para trabalhar com as Cartas.
  """
  defstruct [:rank, :value]

  @rank_value %{
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "T" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13,
    "A" => 14
  }

  @rank_value_02 %{
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "T" => 10,
    "J" => 1,
    "Q" => 12,
    "K" => 13,
    "A" => 14
  }

  # - Cria uma nova Carta
  def new(card) do
    %Card{
      rank: card,
      value: @rank_value[card]
    }
  end

  # - Cria uma nova Carta com a alteração
  # necessária para a parte 02 do problema.
  def new_02(card) do
    %Card{
      rank: card,
      value: @rank_value_02[card]
    }
  end

  # - Compara duas Cartas
  def compare(%Card{value: r1}, %Card{value: r2}) when r1 < r2, do: :lt
  def compare(%Card{value: r1}, %Card{value: r2}) when r1 > r2, do: :gt
  def compare(%Card{}, %Card{}), do: :eq
end
