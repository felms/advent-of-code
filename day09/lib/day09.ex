defmodule Day09 do
  @moduledoc """
  Dia 09 do Advent of Code 2022
  """

  # Para usar funções matemáticas
  alias :math, as: Math
  
  # ======= Problema 01 - Numero de posições visitadas pela
  # cauda da corda
  def positions_visited do

    head_position = {0, 0}

    File.read!("./input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn string_move -> 
      [move, str_step] = String.split(string_move)
      {move, String.to_integer(str_step)}
    end)
    |> Enum.reduce(head_position, fn move, acc -> 
      move_head(acc, move)
    end)

  end

  # - Move a cabeça da corda o numero
  # de passos informados na direção informada
  def move_head(head_position, move) do

    {direction, steps} = move

    Enum.to_list(1..steps)
    |> Enum.reduce(head_position, fn _step, acc -> 
      IO.inspect(acc)
      move_one_step(acc, direction)
    end)

  end

  # - Move 1 passo na direção informada
  defp move_one_step(head_position, direction) do

    {head_x, head_y} = head_position

    cond do
      direction === "R" -> {head_x + 1, head_y}
      direction === "D" -> {head_x, head_y - 1}
      direction === "L" -> {head_x - 1, head_y}
      direction === "U" -> {head_x, head_y + 1}
    end

  end

  # - Calcula a distância entre dois pontos
  defp distance_between_points(point0, point1) do
    {x0, y0} = point0
    {x1, y1} = point1

    x = Math.pow(x1 - x0, 2)
    y = Math.pow(y1 - y0, 2)

    Math.sqrt(x + y) |> round

  end
  
end
