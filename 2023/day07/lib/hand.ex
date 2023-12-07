defmodule Hand do
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

  def new(hand) do
    [cards_string, bid_string] = hand |> String.split(~r/\s+/, trim: true)
    cards = cards_string |> String.graphemes() |> Enum.map(&Card.new/1)

    %Hand{
      cards: cards,
      category: categorize_hand(cards),
      bid: bid_string |> String.to_integer()
    }
  end

  def print_hand(hand) do
    hand.cards
    |> Enum.map(&Card.print_card/1)
  end

  defp categorize_hand(hand) do
    cond do
      five_of_a_kind?(hand) -> :five_of_a_kind
      four_of_a_kind?(hand) -> :four_of_a_kind
      three_of_a_kind?(hand) and one_pair?(hand) -> :full_house
      three_of_a_kind?(hand) -> :three_of_a_kind
      two_pair?(hand) -> :two_pair
      one_pair?(hand) -> :one_pair
      true -> :high_card
    end
  end

  defp five_of_a_kind?(hand) do
    hand
    |> Enum.map(fn card -> card.rank end)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.member?(5)
  end

  defp four_of_a_kind?(hand) do
    hand
    |> Enum.map(fn card -> card.rank end)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.member?(4)
  end

  defp three_of_a_kind?(hand) do
    hand
    |> Enum.map(fn card -> card.rank end)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.member?(3)
  end

  defp two_pair?(hand) do
    hand
    |> Enum.map(fn card -> card.rank end)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort(:desc)
    |> then(&(&1 == [2, 2, 1]))
  end

  defp one_pair?(hand) do
    hand
    |> Enum.map(fn card -> card.rank end)
    |> Enum.frequencies()
    |> Map.values()
    |> then(&(2 in &1))
  end

  def compare(%Hand{category: c1, cards: cd1}, %Hand{category: c2, cards: cd2}) do
    cond do
      @categories[c1] < @categories[c2] -> :lt
      @categories[c1] > @categories[c2] -> :gt
      @categories[c1] == @categories[c2] -> break_tie(cd1, cd2, 0)
    end
  end

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
