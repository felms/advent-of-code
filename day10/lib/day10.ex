defmodule Day10 do
  @moduledoc """
  Dia 10 do Advent of Code 2022
  """
  # ======= Problema 01 - Soma da 'força do sinal'
  # em diferentes pontos
  def signal_strength_sum do

    {_, signal_strength} = File.read!("./input.txt")
    |> String.split("\n", trim: true)
    |> Enum.reduce({0, %{0 => 1}}, fn command, acc -> 

      {index, map} = acc
      previous = Map.get(map, index)

      cond do
        command === "noop" -> 
          new_index = index + 1
          {new_index, Map.put(map, new_index, previous)}
        String.match?(command, ~r/add/) -> 
          [_, number] = String.split(command)
          new_value = previous + String.to_integer(number)
          new_index = index + 1
          new_map = Map.put(map, new_index, previous) |> Map.put(new_index + 1, new_value)
          {new_index + 1, new_map}
      end

    end)

    twenty = Map.get(signal_strength, 19) * 20
    sixty = Map.get(signal_strength, 59) * 60
    hundred = Map.get(signal_strength, 99) * 100
    hundred_and_forty = Map.get(signal_strength, 139) * 140
    hundred_and_eigty = Map.get(signal_strength, 179) * 180
    two_hundred_and_twenty = Map.get(signal_strength, 219) * 220

    [twenty, sixty, hundred, hundred_and_forty, hundred_and_eigty, two_hundred_and_twenty]
    |> Enum.sum

  end

end
