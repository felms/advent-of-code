defmodule Day14V2 do
  @moduledoc """
  Dia 14 do Advent of Code de 2021
  """

  @number_of_steps 10

  # Roda o problema no modo correto (teste ou real)
  def run(), do: solve("sample_input.txt")
  def run(:real), do: solve("input.txt")

  # Chama o método para a solução do problema
  defp solve(input_file) do
    input = parse_input(input_file)

    # {time, result} = :timer.tc(&part_01/1, [input])

    # IO.puts(
    #   "==Part 01== \nResult:\n#{result}" <>
    #     "\nCalculated in #{time / 1_000_000} seconds\n"
    # )

    # {time, result} = :timer.tc(&part_02/1, [input])

    # IO.puts(
    #   "==Part 02== \nResult: \n\n#{result}" <>
    #     "\n\nCalculated in #{time / 1_000_000} seconds\n"
    # )
  end

  defp parse_input(file) do
    [template, rules] =
      File.read!(file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.split("\n\n", trim: true)

    State.init(template, rules)
  end

  # ======= Problema 01
  # defp part_01({template, rules}) do

  # end

  # ======= Problema 02
  # defp part_02({points, folds}) do
  # end

  # ======= Utilitários
  
end
