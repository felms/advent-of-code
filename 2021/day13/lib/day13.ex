defmodule Day13 do
  @moduledoc """
  Dia 13 do Advent of Code de 2021
  """

  # Roda o problema no modo correto (teste ou real)
  def run(), do: solve("sample_input.txt")
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
    [dots, instructions] =
      File.read!(file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.split("\n\n", trim: true)

    dots_set =
      dots
      |> String.split("\n")
      |> Enum.map(&parse_dot/1)
      |> MapSet.new()

    folds =
      instructions
      |> String.split("\n")
      |> Enum.map(&parse_fold/1)

    {dots_set, folds}
  end

  defp parse_dot(dot) do
    [x, y] = String.split(dot, ",")
    {String.to_integer(x), String.to_integer(y)}
  end

  defp parse_fold(fold) do
    fold
    |> String.replace("fold along ", "")
  end

  defp execute_fold(points, fold) do
    cond do
      fold =~ ~r/x/ -> fold_x(points, String.replace(fold, "x=", "") |> String.to_integer())
      fold =~ ~r/y/ -> fold_y(points, String.replace(fold, "y=", "") |> String.to_integer())
    end
  end

  defp fold_x(points, x_value) do
    points
    |> MapSet.to_list()
    |> Enum.map(fn {x, y} -> 
      new_x = if x > x_value, do: 2 * x_value - x, else: x
      {new_x, y}
    end)
    |> MapSet.new()
  end

  defp fold_y(points, y_value) do
    points
    |> MapSet.to_list()
    |> Enum.map(fn {x, y} -> 
      new_y = if y > y_value, do: 2 * y_value - y, else: y
      {x, new_y}
    end)
    |> MapSet.new()
  end

  # ======= Problema 01
  defp part_01({points, folds}) do
    execute_fold(points, hd(folds))
    |> MapSet.size()
  end
end
