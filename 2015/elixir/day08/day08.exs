defmodule Day08 do
  @moduledoc """
  Dia 08 do Advent of Code de 2015
  """

  def run(input_file) do

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)

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
    input
    |> Enum.map(&string_score/1)
    |> Enum.sum()
  end

  # - Problema 02
  def part02(input) do
    input
    |> Enum.reduce(0, fn string, acc ->
      val0 = string |> encode_string() |> characters_of_code()
      val1 = string |> characters_of_code()
      val0 - val1 + acc
    end)
  end

  def string_score(string) do
    characters_of_code(string) - characters_in_memory(string)
  end

  def characters_of_code(string), do: string |> String.length()

  def characters_in_memory(string) do
    characters_in_memory(String.graphemes(string), :normal, 0)
  end

  def characters_in_memory([], _mode, count), do: count

  def characters_in_memory(["\"" | remaining_chars], :normal, count) do
    characters_in_memory(remaining_chars, :normal, count)
  end

  def characters_in_memory(["\\" | remaining_chars], :normal, count) do
    characters_in_memory(remaining_chars, :escape, count)
  end

  def characters_in_memory(["x" | remaining_chars], :escape, count) do
    [_, _ | rem_chars] = remaining_chars
    characters_in_memory(rem_chars, :normal, count + 1)
  end

  def characters_in_memory([_ | remaining_chars], _mode, count) do
    characters_in_memory(remaining_chars, :normal, count + 1)
  end

  def encode_string(string) do
    encode_string(String.graphemes(string), "")
  end

  def encode_string([], str), do: "\"" <> str <> "\""

  def encode_string(["\"" | remaining_chars], str) do
    encode_string(remaining_chars, str <> "\\\"")
  end

  def encode_string(["\\" | remaining_chars], str) do
    encode_string(remaining_chars, str <> "\\\\")
  end

  def encode_string([char | remaining_chars], str) do
    encode_string(remaining_chars, str <> char)
  end
end

# ---- Run

System.argv
|> hd
|> Day08.run
