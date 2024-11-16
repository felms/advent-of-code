defmodule Day08 do
  @moduledoc """
  Dia 08 do Advent of Code de 2021
  """

  @mappings %{
    zero: [],
    one: [],
    two: [],
    three: [],
    four: [],
    five: [],
    six: [],
    seven: [],
    eight: [],
    nine: []
  }

  def run(input_file) do
    input = parse_input(input_file)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "==Part 02== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  defp parse_input(file) do
    File.read!(file)
    # Para evitar problemas no Windows 
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
  end

  defp part_01(input) do
    input
    |> Enum.map(&String.replace(&1, ~r/.*\|/, ""))
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> List.flatten()
    |> Enum.filter(&(String.length(&1) in [2, 3, 4, 7]))
    |> length()
  end

  defp part_02(input) do
    input
    |> Enum.map(&String.split(&1, ~r/\|/, trim: true))
    |> Enum.map(&decode/1)
    |> Enum.sum()
  end

  defp decode([patterns, output_value]) do
    mappings = find_mappings(patterns)

    output_value
    |> String.split(" ", trim: true)
    |> Enum.map(&(decode_number(&1, mappings)))
    |> Integer.undigits()

  end

  defp decode_number(number, mappings) do
    number_list = 
      number
      |> String.graphemes()
      |> Enum.sort()

    cond do
      mappings.zero  == number_list -> 0
      mappings.one  == number_list -> 1
      mappings.two  == number_list -> 2
      mappings.three  == number_list -> 3
      mappings.four  == number_list -> 4
      mappings.five  == number_list -> 5
      mappings.six  == number_list -> 6
      mappings.seven  == number_list -> 7
      mappings.eight  == number_list -> 8
      mappings.nine  == number_list -> 9
    end
    
  end

  defp find_mappings(patterns) do
    patterns_list =
    patterns
    |> String.split(" ", trim: true)
    |> Enum.map(&(&1 |> String.graphemes() |> Enum.sort()))


    patterns_list
    |> find_four_seven_eight(@mappings)
    |> find_zero_six_nine(patterns_list)
    |> find_two_three_five(patterns_list)
  end

  defp find_four_seven_eight([], mappings), do: mappings
  defp find_four_seven_eight([h | t], mappings) do
    case length(h) do
      2 -> find_four_seven_eight(t, %{mappings | one: h})
      3 -> find_four_seven_eight(t, %{mappings | seven: h})
      4 -> find_four_seven_eight(t, %{mappings | four: h})
      7 -> find_four_seven_eight(t, %{mappings | eight: h})
      _ -> find_four_seven_eight(t, mappings)
    end
  end

  defp find_zero_six_nine(mappings, []), do: mappings
  defp find_zero_six_nine(mappings, [h | t]) do
    cond do
      length(h) == 6 and Enum.all?(mappings.four, &(&1 in h)) -> find_zero_six_nine(%{mappings | nine: h}, t)
      length(h) == 6 and Enum.all?(mappings.seven, &(&1 in h)) -> find_zero_six_nine(%{mappings | zero: h}, t)
      length(h) == 6 -> find_zero_six_nine(%{mappings | six: h}, t)
      true -> find_zero_six_nine(mappings, t)
    end
  end

  defp find_two_three_five(mappings, []), do: mappings
  defp find_two_three_five(mappings, [h | t]) do
    cond do
      length(h) == 5 and Enum.all?(h, &(&1 in mappings.six)) -> find_two_three_five(%{mappings | five: h}, t)
      length(h) == 5 and Enum.all?(mappings.seven, &(&1 in h)) -> find_two_three_five(%{mappings | three: h}, t)
      length(h) == 5 -> find_two_three_five(%{mappings | two: h}, t)
      true -> find_two_three_five(mappings, t)
    end
  end

end

# ---- Run
System.argv
|> hd
|> Day08.run
