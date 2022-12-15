defmodule Day13 do
  @moduledoc """
  Dia 13 do Advento of Code 2022
  """

  # ======= Problema 01 - Soma dos indices dos pares de listas ordenadas
  def part_01(input) do

    parse_input(input)
    |> Enum.with_index(1)
    |> Enum.into(%{}, fn {v, i} -> {i, v} end)
    |> Enum.reduce(0, fn {k, v}, acc ->
      {l, r} = v
      case sorter(l, r) do
        true -> acc + k
        false -> acc
      end
    end)
  end

  # - Parse do input
  defp parse_input(input) do

    input
    |> File.read!
    |> String.replace("\r", "")
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_pair/1)

  end

  # - Faz o parse de uma string em um par de listas
  defp parse_pair(pair) do
    [left, right] = String.split(pair, "\n", trim: true)
    {l, _} = Code.eval_string(left)
    {r, _} = Code.eval_string(right)
    {l, r}
  end


  # - Confere se as listas estão ordenadas
  def sorter([], []), do: :cont
  def sorter(l, r) when is_list(l) and is_integer(r), do: sorter(l, [r])
  def sorter(l, r) when is_integer(l) and is_list(r), do: sorter([l], r)

  def sorter([], _), do: true
  def sorter(_, []), do: false

  def sorter([lh | lt], [rh | rt]) do
    res = sorter(lh, rh)
    if res === :cont do
      sorter(lt, rt)
    else
      res
    end
  end

  def sorter(l, r) when is_integer(l) and is_integer(r) do
    cond do
      l < r -> true
      l > r -> false
      true -> :cont
    end
  end
end
