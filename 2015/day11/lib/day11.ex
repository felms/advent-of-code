defmodule Day11 do
  @moduledoc """
  Dia 11 do Advent of Code de 2015
  """
  @alphabet ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
             "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
             "u", "v", "w", "x", "y", "z"]

  @increasing_straights [ "abc", "bcd", "cde", "def", "efg", 
                          "fgh", "ghi", "hij", "ijk", "jkl",
                          "klm", "lmn", "mno", "nop", "opq",
                          "pqr", "qrs", "rst", "stu", "tuv",
                          "uvw", "vwx", "wxy", "xyz" ]

  def meets_first_requirement?(input), do: String.contains?(input, @increasing_straights)

  def meets_second_requirement?(input), do: !(input =~ ~r/[iol]/)
  def meets_third_requirement?(input), do: Regex.scan(~r/(\w)\1{1}/, input) |> length >= 2

  def valid_password?(input),
    do:
      meets_first_requirement?(input) && meets_second_requirement?(input) &&
        meets_third_requirement?(input)

  def next_valid_password(password) do
    new_password = next_password(password)

    if valid_password?(new_password), 
      do: new_password, else: next_valid_password(new_password)
  end

  def next_password(input) do
    
    if input =~ ~r/[iol]/, do: input |> String.graphemes |> get_next_valid |> Enum.join,
      else: input |> String.graphemes |> Enum.reverse |> get_next |> Enum.reverse |> Enum.join
  end

  def get_next_valid(["i" | remaining_word]), do: ["j" | fill_with_a(remaining_word)]
  def get_next_valid(["l" | remaining_word]), do: ["m" | fill_with_a(remaining_word)]
  def get_next_valid(["o" | remaining_word]), do: ["p" | fill_with_a(remaining_word)]
  def get_next_valid([first_letter | remaining_word]), do: [first_letter| get_next_valid(remaining_word)]

  def get_next(["z" | remaining_word]), do: ["a" | get_next(remaining_word)]
  def get_next([first_letter | remaining_word]), 
    do: [get_next_letter(first_letter) | remaining_word]

  def get_next_letter(letter), 
    do: Enum.at(@alphabet, 
      Enum.find_index(@alphabet, &(String.equivalent?(&1, letter))) + 1)

  def fill_with_a(word), do: (for _ <- 1..(word |> length), do: "a")
end
