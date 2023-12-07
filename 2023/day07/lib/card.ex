defmodule Card do
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

  def new(card) do
    %Card{
      rank: card,
      value: @rank_value[card]
    }
  end

  def print_card(card) do
    "#{card.rank}"
  end

  def compare(%Card{value: r1}, %Card{value: r2}) when r1 < r2, do: :lt
  def compare(%Card{value: r1}, %Card{value: r2}) when r1 > r2, do: :gt
  def compare(%Card{}, %Card{}), do: :eq
end
