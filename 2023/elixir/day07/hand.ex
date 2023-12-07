defmodule Hand do
  @moduledoc """
  Define uma "Mão" do jogo e funções auxiliares
  para trabalhar com uma "Mão".
  """
  
  Code.require_file("card.ex")
  
  defstruct [:cards, :category, :bid]

  @categories %{
    five_of_a_kind: 7,
    four_of_a_kind: 6,
    full_house: 5,
    three_of_a_kind: 4,
    two_pair: 3,
    one_pair: 2,
    high_card: 1
  }

  # - Cria uma nova Mão
  def new(hand) do
    [cards_string, bid_string] = hand |> String.split(~r/\s+/, trim: true)
    cards = cards_string |> String.graphemes() |> Enum.map(&Card.new/1)

    %Hand{
      cards: cards,
      category: categorize_hand(cards),
      bid: bid_string |> String.to_integer()
    }
  end

  # - Cria uma nova Mão com as alterações
  # necessárias para a parte 02 do problema.
  def new_02(hand) do
    [cards_string, bid_string] = hand |> String.split(~r/\s+/, trim: true)
    cards = cards_string |> String.graphemes() |> Enum.map(&Card.new_02/1)

    %Hand{
      cards: cards,
      category: categorize_hand_02(cards),
      bid: bid_string |> String.to_integer()
    }
  end

  # - Categoriza uma Mão
  defp categorize_hand(hand) do
    freqs = hand |> Enum.frequencies() |> Enum.map(fn {_k, v} -> v end) |> Enum.sort(:desc)

    case freqs do
      [5] -> :five_of_a_kind
      [4, 1] -> :four_of_a_kind
      [3, 2] -> :full_house
      [3 | _] -> :three_of_a_kind
      [2, 2, 1] -> :two_pair
      [2 | _] -> :one_pair
      _ -> :high_card
    end
  end

  # - Categoriza uma Mão com as alterações
  # necessárias para a parte 02 do problema.
  defp categorize_hand_02(hand) do
    number_of_jokers = hand |> Enum.count(fn card -> card.rank == "J" end)

    freq_without_jokers =
      hand
      |> Enum.reject(fn card -> card.rank == "J" end)
      |> Enum.frequencies()
      |> Enum.map(fn {_k, v} -> v end)
      |> Enum.sort(:desc)

    freqs =
      if freq_without_jokers == [],
        do: [number_of_jokers],
        else: [number_of_jokers + (freq_without_jokers |> hd) | freq_without_jokers |> tl()]

    case freqs do
      [5] -> :five_of_a_kind
      [4, 1] -> :four_of_a_kind
      [3, 2] -> :full_house
      [3 | _] -> :three_of_a_kind
      [2, 2, 1] -> :two_pair
      [2 | _] -> :one_pair
      _ -> :high_card
    end
  end

  # - Compara duas Mãos (usado no Enum.sort/1)
  def compare(%Hand{category: c1, cards: cd1}, %Hand{category: c2, cards: cd2}) do
    cond do
      @categories[c1] < @categories[c2] -> :lt
      @categories[c1] > @categories[c2] -> :gt
      @categories[c1] == @categories[c2] -> break_tie(cd1, cd2, 0)
    end
  end

  # - Executa o desempate na comparação de duas Mãos
  def break_tie(cards0, cards1, 5) do
    Card.compare(
      Enum.at(cards0, 5),
      Enum.at(cards1, 5)
    )
  end

  def break_tie(cards0, cards1, pos) do
    res = Card.compare(Enum.at(cards0, pos), Enum.at(cards1, pos))

    case res do
      :eq -> break_tie(cards0, cards1, pos + 1)
      _ -> res
    end
  end
end
