defmodule Day13 do
  @moduledoc """
  Dia 13 do Advento of Code 2022
  """
  def part_01(input) do

    parse_input(input)

  end

  defp parse_input(input) do

    input
    |> File.read!
    |> String.replace("\r", "")
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_pair/1)
    
  end

  defp parse_pair(pair) do
    [left, right] = String.split(pair, "\n", trim: true)
    {l, _} = Code.eval_string(left)
    {r, _} = Code.eval_string(right)
    {l, r}
  end

end
