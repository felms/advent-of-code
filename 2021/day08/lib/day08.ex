defmodule Day08 do
  @moduledoc """
  Dia 08 do Advent of Code de 2021
  """
  # Roda o problema no modo correto (teste ou real)
  def run(:sample), do: solve("sample_input.txt")
  def run(:real), do: solve("input.txt")

  # Chama o método para a solução do problema
  defp solve(input_file) do
    input = parse_input(input_file)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    # {time, result} = :timer.tc(&part_02/1, [input])

    # IO.puts(
    #   "==Part 02== \nResult: #{result}" <>
    #     "\nCalculated in #{time / 1_000_000} seconds\n"
    # )
  end

  defp parse_input(file) do
    File.read!(file) 
    |> String.replace("\r", "")  # Para evitar problemas no Windows 
    |> String.split("\n", trim: true)
  end

  defp part_01(input) do
    input
    |> Enum.map(&(String.replace(&1, ~r/.*\|/, "")))
    |> Enum.map(&(String.split(&1, " ", trim: true)))
    |> List.flatten()
    |> Enum.filter(&(String.length(&1) in [2, 3, 4, 7]))
    |> length()
  end
end
