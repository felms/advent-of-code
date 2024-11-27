defmodule Day13 do
  @moduledoc """
  Dia 13 do Advent of Code de 2021
  """

  def run(input_file) do
    input = parse_input(input_file)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult:\n#{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "==Part 02== \nResult: \n\n#{result}" <>
        "\n\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  defp parse_input(file) do
    [dots, instructions] =
      File.read!(file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.split("\n\n", trim: true)

    dots_set =
      dots
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_dot/1)
      |> MapSet.new()

    folds =
      instructions
      |> String.split("\n", trim: true)
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

  # ======= Problema 01
  defp part_01({points, folds}) do
    execute_fold(points, hd(folds))
    |> MapSet.size()
  end

  # ======= Problema 02
  defp part_02({points, folds}) do
    execute_folds(points, folds)
    |> print_dots()
  end

  # ======= Utilitários

  defp execute_folds(points, []), do: points
  defp execute_folds(points, [fold | remaining_folds]) do
    points
    |> execute_fold(fold)
    |> execute_folds(remaining_folds)
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

  defp print_dots(points) do
    points
    |> get_maxes()
    |> generate_grid()
    |> Enum.map(&print_row(&1, points))
    |> Enum.join("\n")
  end

  defp get_maxes(points) do
    points_list = MapSet.to_list(points)

    max_x =
      points_list
      |> Enum.map(fn {x, _y} -> x end)
      |> Enum.max()

    max_y =
      points_list
      |> Enum.map(fn {_x, y} -> y end)
      |> Enum.max()

    {max_x, max_y}
  end

  defp generate_grid({max_x, max_y}) do
    grid = for x <- 0..max_x, y <- 0..max_y, do: {x, y}

    grid
    |> Enum.group_by(fn {_x, y} -> y end)
    |> Enum.map(fn {_k, v} -> v end)
  end

  defp print_row(row, points) do
    row
    |> Enum.map(fn point ->
      if point in points, do: "#", else: "."
    end)
    |> Enum.join(" ")
  end
end

# ---- Run
System.argv
|> hd
|> Day13.run