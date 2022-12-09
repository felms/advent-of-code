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
							|> String.replace("\r", "") # Para evitar problemas no Windows
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
    #{head_pos, tail_list |> hd, number_of_visisted_pos}
	number_of_visisted_pos

  end

  # ======= Problema 02 - Numero de posições visitadas 
  # pelo ultimo nó da da corda
  def positions_visited_by_the_tail_node do

    head_position = {0, 0}
    tail_nodes = %{
      1 => [{0, 0}], 
      2 => [{0, 0}], 
      3 => [{0, 0}], 
      4 => [{0, 0}], 
      5 => [{0, 0}], 
      6 => [{0, 0}], 
      7 => [{0, 0}], 
      8 => [{0, 0}], 
      9 => [{0, 0}] 
    }

    {_head_pos, tail_list} = File.read!("./input.txt")
							|> String.replace("\r", "") # Para evitar problemas no Windows
                            |> String.split("\n", trim: true)
                            |> Enum.map(fn string_move -> 
                              [move, str_step] = String.split(string_move)
                              {move, String.to_integer(str_step)}
                            end)
                            |> Enum.reduce({head_position, tail_nodes}, fn move, acc -> 
                              {h, t} = acc
                              move_head_2(h, t, move)
                            end)
    Map.get(tail_list, 9) |> Enum.uniq |> length

  end


  # ======= Utilitários

  # - Move a cabeça da corda o numero
  # de passos informados na direção informada
  defp move_head(head_position, tail_map, move) do

    {direction, steps} = move

    Enum.to_list(1..steps)
    |> Enum.reduce({head_position, tail_map}, fn _step, acc -> 
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

  # - Move a cabeça da corda (e os nós case necessário)
  # o numero de passos informados na direção informada
  defp move_head_2(head_position, tail, move) do

    {direction, steps} = move

    Enum.to_list(1..steps)
    |> Enum.reduce({head_position, tail}, fn _step, acc -> 

      {h, t} = acc
      new_head = move_one_step(h, direction)

      first = Map.get(t, 1)
      new_first = move_tail_if_needed(new_head, first)

      second = Map.get(t, 2)
      new_second = move_tail_if_needed(new_first |> hd, second)

      third = Map.get(t, 3)
      new_third = move_tail_if_needed(new_second |> hd, third)

      fourth = Map.get(t, 4)
      new_fourth = move_tail_if_needed(new_third |> hd, fourth)

      fifth = Map.get(t, 5)
      new_fifth = move_tail_if_needed(new_fourth |> hd, fifth)

      sixth = Map.get(t, 6)
      new_sixth = move_tail_if_needed(new_fifth |> hd, sixth)

      seventh = Map.get(t, 7)
      new_seventh = move_tail_if_needed(new_sixth |> hd, seventh)

      eighth = Map.get(t, 8)
      new_eighth = move_tail_if_needed(new_seventh |> hd, eighth)

      ninth = Map.get(t, 9)
      new_ninth = move_tail_if_needed(new_eighth |> hd, ninth)

      new_t = Map.put(t, 1, new_first) |> Map.put(2, new_second) |> Map.put(3, new_third)
              |> Map.put(4, new_fourth) |> Map.put(5, new_fifth) |> Map.put(6, new_sixth)
              |> Map.put(7, new_seventh) |> Map.put(8, new_eighth) |> Map.put(9, new_ninth)

      {new_head, new_t}

    end)

  end

  # - Auxiliar para a parte 02
  # move o nó apenas se necessário
  defp move_tail_if_needed(new_head, tail) do
    [current_tail | _] = tail
    cond do
      distance_between_points(new_head, current_tail) > 1 -> 
        new_tail = move_tail(new_head, current_tail)
        [new_tail | tail]
      true -> tail
    end
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

      # caso default
      true -> tail_position

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

# --- Run
IO.puts("Part 01")
Day09.positions_visited
|> IO.puts

IO.puts("\nPart 02")
Day09.positions_visited_by_the_tail_node
|> IO.puts