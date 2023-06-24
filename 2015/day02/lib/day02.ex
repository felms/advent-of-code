defmodule Day02 do
  @moduledoc """
  Dia 02 do Advent of Code de 2015
  """

  def run() do
    input = parse_input("input.txt")

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult:\n#{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    # {time, result} = :timer.tc(&part_02/1, [input])

    # IO.puts(
    #  "==Part 02== \nResult: \n\n#{result}" <>
    #    "\nCalculated in #{time / 1_000_000} seconds\n"
    # )
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
    |> Enum.map(&required_wrapping_paper/1)
    |> Enum.sum()
  end

  defp required_wrapping_paper(box_dimensions) do
    [l, w, h] = String.split(box_dimensions, "x", trim: true) |> Enum.map(&String.to_integer/1)

    side0 = l * w
    side1 = w * h
    side2 = h * l
    slack = Enum.min([side0, side1, side2])

    2 * side0 + 2 * side1 + 2 * side2 + slack
  end

  # ======= Problema 02
  # defp part_02(input) do
  #  input
  #  |> find_pos(0, 0)
  # end
end
