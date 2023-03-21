defmodule Day11 do
  @moduledoc """
  Dia 11 do Advent of Code de 2021
  """
  @number_of_steps 100

  # Roda o problema no modo correto (teste ou real)
  def run(:sample), do: solve("sample_input.txt")
  def run(:real), do: solve("input.txt")

  # Chama o método para a solução do problema
  defp solve(input_file) do
    input = parse_input(input_file)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult:\n#{result}" <>
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
    # Para evitar problemas no Windows
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {row, index} -> {index, parse_row(row)} end)
    |> Enum.map(&to_matrix/1)
    |> List.flatten()
    |> Enum.into(%{})
  end

  # ======= Problema 01
  defp part_01(input) do
    Enum.reduce(1..@number_of_steps, input, fn _, acc ->
      Cave.execute_step(acc)
    end)
    |> print_matrix()
  end

  # ======= Problema 02
  # defp part_02(input) do
  # end

  # ======= Funções auxiliares
  defp parse_row(row) do
    row
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.map(fn {value, index} -> {index, value} end)
  end

  defp to_matrix({index, list}) do
    list
    |> Enum.map(fn {k, v} -> {{index, k}, v} end)
  end

  defp print_matrix(matrix) do
    max_x =
      matrix
      |> Enum.map(fn {{x, _y}, _v} -> x end)
      |> Enum.max()

    Enum.reduce(0..max_x, [], fn index, acc ->
      row =
        Enum.filter(matrix, fn {{x, _y}, _v} -> x == index end)
        |> Enum.sort(fn {{_, y0}, _}, {{_, y1}, _} -> y1 >= y0 end)
        |> print_row()

      [row | acc]
    end)
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  defp print_row(row) do
    row
    |> Enum.map(fn {{_x, _y}, v} -> Integer.to_string(v) end)
    |> Enum.join()
  end
end
