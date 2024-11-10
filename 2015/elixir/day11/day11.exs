defmodule Day11 do
  @moduledoc """
  Dia 11 do Advent of Code de 2015
  """
  @alphabet [ "a", "b", "c", "d", "e", "f", 
              "g", "h", "i", "j", "k", "l", 
              "m", "n", "o", "p", "q", "r", 
              "s", "t", "u", "v", "w", "x", 
              "y", "z" ]

  @increasing_straights [ "abc", "bcd", "cde", "def", "efg",
                          "fgh", "ghi", "hij", "ijk", "jkl",
                          "klm", "lmn", "mno", "nop", "opq",
                          "pqr", "qrs", "rst", "stu", "tuv",
                          "uvw", "vwx", "wxy", "xyz" ]

  def run() do
    input = "hepxcrrq"

    {time, result} = :timer.tc(&part01/1, [input])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part02/1, [input])

    IO.puts(
      "\n==Part 02== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  # - Problema 01
  def part01(input) do
    input |> next_valid_password
  end

  # - Problema 02
  def part02(input) do
    input |> next_valid_password |> next_valid_password
  end

  def meets_first_requirement?(input), do: String.contains?(input, @increasing_straights)

  def meets_second_requirement?(input), do: !(input =~ ~r/[iol]/)
  def meets_third_requirement?(input), do: Regex.scan(~r/(\w)\1{1}/, input) |> length >= 2

  def valid_password?(input),
    do:
      meets_first_requirement?(input) && meets_second_requirement?(input) &&
        meets_third_requirement?(input)

  def next_valid_password(password) do
    new_password = next_password(password)

    if valid_password?(new_password), do: new_password, else: next_valid_password(new_password)
  end

  def next_password(input) do
    if input =~ ~r/[iol]/,
      do: input |> get_next_valid,
      else:
        input |> String.graphemes() |> Enum.reverse() |> get_next |> Enum.reverse() |> Enum.join()
  end

  def get_next_valid(word),
    do:
      word
      |> String.replace(~r/([^iol]*)([iol]).*/, "\\1\\2")
      |> String.pad_trailing(String.length(word), "a")
      |> String.replace("i", "j")
      |> String.replace("l", "m")
      |> String.replace("o", "p")

  def get_next(["z" | remaining_word]), do: ["a" | get_next(remaining_word)]

  def get_next([first_letter | remaining_word]),
    do: [get_next_letter(first_letter) | remaining_word]

  def get_next_letter(letter),
    do:
      Enum.at(
        @alphabet,
        Enum.find_index(@alphabet, &String.equivalent?(&1, letter)) + 1
      )
end

# ---- Run

Day11.run