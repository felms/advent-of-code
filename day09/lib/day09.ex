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
    tail = [{0, 0}]

    {head_pos, tail_list} = File.read!("./input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn string_move -> 
      [move, str_step] = String.split(string_move)
      {move, String.to_integer(str_step)}
    end)
    |> Enum.reduce({head_position, tail}, fn move, acc -> 
      {h, t} = acc
      move_head(h, t, move)
    end)
    
    number_of_visisted_pos = tail_list |> Enum.uniq |> length
    {head_pos, tail_list |> hd, number_of_visisted_pos}

  end

  # ======= Utilitários

  # - Move a cabeça da corda o numero
  # de passos informados na direção informada
  defp move_head(head_position, tail, move) do

    {direction, steps} = move

    Enum.to_list(1..steps)
    |> Enum.reduce({head_position, tail}, fn _step, acc -> 
      {h, t} = acc
      new_head = move_one_step(h, direction)
      current_tail = t |> hd
      cond do
        distance_between_points(new_head, current_tail) > 1 -> 
          new_tail = move_tail(new_head, current_tail)
          {new_head, [new_tail | t]}
        true -> {new_head, t}
      end
    end)

  end

  # - Move a cauda da corda
  defp move_tail(head_position, tail_position) do
    {head_x, head_y} = head_position
    {tail_x, tail_y} = tail_position

    cond do

      # mesma linha
      head_x === tail_x and head_y < tail_y -> {tail_x, tail_y - 1}
      head_x === tail_x and head_y > tail_y -> {tail_x, tail_y + 1}

      # mesma coluna
      head_x < tail_x and head_y === tail_y -> {tail_x - 1, tail_y}
      head_x > tail_x and head_y === tail_y -> {tail_x + 1, tail_y}

      # diagonais
      head_x > tail_x and head_y > tail_y -> {tail_x + 1, tail_y + 1}
      head_x < tail_x and head_y < tail_y -> {tail_x - 1, tail_y - 1}
      head_x > tail_x and head_y < tail_y -> {tail_x + 1, tail_y - 1}
      head_x < tail_x and head_y > tail_y -> {tail_x - 1, tail_y + 1}

    end

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
