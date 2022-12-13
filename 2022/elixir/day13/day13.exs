defmodule Day13 do
  @moduledoc """
  Dia 13 do Advent of Code 2022
  """

  def run(mode) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

    {time, result} = :timer.tc(&part_01/1, [input_file])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part_02/1, [input_file])

    IO.puts(
      "\n==Part 02== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

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

  # ======= Problema 02 - Produto dos indices dos 'divider packets'
  # depois de ordenar toda a lista (incluindo eles)
  def part_02(input) do

    divider_packet0 = [[2]]
    divider_packet1 = [[6]]

    parse_input(input)
    |> Enum.flat_map(fn {x, y} -> [x, y] end)
    |> Kernel.++([divider_packet0, divider_packet1])
    |> Enum.sort(&sorter/2)
    |> Enum.with_index(1)
    |> Enum.reduce(1, fn {packet, index}, acc ->
      cond do
        packet === divider_packet0 -> index * acc
        packet === divider_packet1 -> index * acc
        true -> acc
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

# --- Run
System.argv()
|> hd
|> String.to_atom
|> Day13.run()