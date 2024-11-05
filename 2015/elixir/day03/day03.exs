defmodule Day03 do
  @moduledoc """
  Dia 03 do Advent of Code de 2015
  """

  def run() do
    input = parse_input("input.txt")

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult:\n#{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "==Part 02== \nResult: \n#{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  defp parse_input(file) do
    File.read!(file)
    # Para evitar problemas no Windows
    |> String.replace("\r", "")
    |> String.trim()
    |> String.graphemes()
  end

  # ======= Problema 01
  defp part_01(input) do
    input
    |> visit({0, 0}, MapSet.put(MapSet.new(), {0, 0}))
    |> MapSet.size()
  end

  defp visit([], _current_pos, visited), do: visited

  defp visit([">" | directions], {x, y}, visited),
    do: visit(directions, {x + 1, y}, MapSet.put(visited, {x + 1, y}))

  defp visit(["v" | directions], {x, y}, visited),
    do: visit(directions, {x, y - 1}, MapSet.put(visited, {x, y - 1}))

  defp visit(["<" | directions], {x, y}, visited),
    do: visit(directions, {x - 1, y}, MapSet.put(visited, {x - 1, y}))

  defp visit(["^" | directions], {x, y}, visited),
    do: visit(directions, {x, y + 1}, MapSet.put(visited, {x, y + 1}))

  # ======= Problema 02
  defp part_02(input) do
    input
    |> visit_rs(
      {0, 0},
      {0, 0},
      :santa,
      MapSet.put(MapSet.new(), {0, 0})
    )
    |> MapSet.size()
  end

  defp visit_rs([], _santa_pos, _robot_santa_pos, _turn, visited), do: visited

  defp visit_rs(
         [">" | directions],
         {x, y},
         robot_santa_pos,
         :santa,
         visited
       ),
       do:
         visit_rs(
           directions,
           {x + 1, y},
           robot_santa_pos,
           :robot_santa,
           MapSet.put(visited, {x + 1, y})
         )

  defp visit_rs(
         ["v" | directions],
         {x, y},
         robot_santa_pos,
         :santa,
         visited
       ),
       do:
         visit_rs(
           directions,
           {x, y - 1},
           robot_santa_pos,
           :robot_santa,
           MapSet.put(visited, {x, y - 1})
         )

  defp visit_rs(
         ["<" | directions],
         {x, y},
         robot_santa_pos,
         :santa,
         visited
       ),
       do:
         visit_rs(
           directions,
           {x - 1, y},
           robot_santa_pos,
           :robot_santa,
           MapSet.put(visited, {x - 1, y})
         )

  defp visit_rs(
         ["^" | directions],
         {x, y},
         robot_santa_pos,
         :santa,
         visited
       ),
       do:
         visit_rs(
           directions,
           {x, y + 1},
           robot_santa_pos,
           :robot_santa,
           MapSet.put(visited, {x, y + 1})
         )

  defp visit_rs(
         [">" | directions],
         santa_pos,
         {x, y},
         :robot_santa,
         visited
       ),
       do:
         visit_rs(
           directions,
           santa_pos,
           {x + 1, y},
           :santa,
           MapSet.put(visited, {x + 1, y})
         )

  defp visit_rs(
         ["v" | directions],
         santa_pos,
         {x, y},
         :robot_santa,
         visited
       ),
       do:
         visit_rs(
           directions,
           santa_pos,
           {x, y - 1},
           :santa,
           MapSet.put(visited, {x, y - 1})
         )

  defp visit_rs(
         ["<" | directions],
         santa_pos,
         {x, y},
         :robot_santa,
         visited
       ),
       do:
         visit_rs(
           directions,
           santa_pos,
           {x - 1, y},
           :santa,
           MapSet.put(visited, {x - 1, y})
         )

  defp visit_rs(
         ["^" | directions],
         santa_pos,
         {x, y},
         :robot_santa,
         visited
       ),
       do:
         visit_rs(
           directions,
           santa_pos,
           {x, y + 1},
           :santa,
           MapSet.put(visited, {x, y + 1})
         )
end

# ---- Run

Day03.run
