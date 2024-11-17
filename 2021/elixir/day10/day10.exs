defmodule Day10 do
  @moduledoc """
  Dia 10 do Advent of Code de 2021
  """

  @error_score %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}
  @completion_score %{")" => 1, "]" => 2, "}" => 3, ">" => 4}

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

  # ======= Problema 01
  defp part_01(input) do
    input
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&check_line(&1, []))
    |> Enum.filter(fn {status, _char} -> status == :corrupted end)
    |> Enum.map(fn {_, char} -> @error_score[char] end)
    |> Enum.sum()
  end

  # ======= Problema 02
  defp part_02(input) do
    scores =
      input
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&check_line(&1, []))
      |> Enum.filter(fn {status, _chars} -> status == :incomplete end)
      |> Enum.map(fn {_status, chars} -> complete_line(chars, []) end)
      |> Enum.map(&score_completion_line/1)
      |> Enum.sort()

    Enum.at(scores, div(length(scores), 2))
  end

  # ======= Funções auxiliares

  defp check_line([], stack), do: {:incomplete, stack}

  defp check_line([current_char | chars], stack) when current_char in ["(", "[", "{", "<"],
    do: check_line(chars, [current_char | stack])

  defp check_line([")" | chars], ["(" | stack]), do: check_line(chars, stack)
  defp check_line(["]" | chars], ["[" | stack]), do: check_line(chars, stack)
  defp check_line(["}" | chars], ["{" | stack]), do: check_line(chars, stack)
  defp check_line([">" | chars], ["<" | stack]), do: check_line(chars, stack)
  defp check_line([current_char | _chars], _stack), do: {:corrupted, current_char}

  defp complete_line([], stack), do: stack |> Enum.reverse()
  defp complete_line(["(" | chars], stack), do: complete_line(chars, [")" | stack])
  defp complete_line(["[" | chars], stack), do: complete_line(chars, ["]" | stack])
  defp complete_line(["{" | chars], stack), do: complete_line(chars, ["}" | stack])
  defp complete_line(["<" | chars], stack), do: complete_line(chars, [">" | stack])

  defp score_completion_line(chars) do
    Enum.reduce(chars, 0, fn char, acc ->
      acc * 5 + @completion_score[char]
    end)
  end
end

# ---- Run
System.argv
|> hd
|> Day10.run
