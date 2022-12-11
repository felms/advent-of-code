defmodule Day11 do
  @moduledoc """
  Dia 11 do Advent of Code 2022
  """


  def parse_input do

    File.read!("./input.txt")
    |> String.split("\n\n")
    |> Enum.map(fn line -> Monkeys.parse_monkey(line) end)
    |> Enum.reduce(%{}, fn monkey, acc -> 
      {id, map} = monkey
      Map.put(acc, id, map)
    end)

  end
  
 end
