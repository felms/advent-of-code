defmodule Day03 do
  @moduledoc """
  Dia 03 do Advent of Code de 2021
  """

  # Roda o problema no modo correto (teste ou real)
  def run(:sample), do: solve("sample_input.txt")
  def run(:real), do: solve("input.txt")

  # Chama o método para a solução do problema
  defp solve(input_file) do
    input = parse_input(input_file)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    # {time, result} = :timer.tc(&part_02/1, [input])

    # IO.puts(
    #   "==Part 02== \nResult: #{result}" <>
    #     "\nCalculated in #{time / 1_000_000} seconds\n"
    # )
  end

  defp part_01(input) do
    input
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> gamma_epsilon_rate(%{gamma_bits: [], epsilon_bits: []})
    |> Enum.map(fn {_k, v} -> v |> Enum.join() |> String.to_integer(2) end)
    |> Enum.product()
  end

  defp parse_input(file) do
    File.read!(file)
    # Para evitar problemas no Windows
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  defp gamma_epsilon_rate([], acc), do: acc

  defp gamma_epsilon_rate([reading | readings], acc) do
    bits = most_and_least_common_bit(reading)

    current_value =
      Map.put(acc, :gamma_bits, acc.gamma_bits ++ [bits.most_common_bit])
      |> Map.put(:epsilon_bits, acc.epsilon_bits ++ [bits.least_common_bit])

    gamma_epsilon_rate(readings, current_value)
  end

  defp most_and_least_common_bit(reading) do
    [{least_common_bit, _freq_1}, {most_common_bit, _freq_2}] =
      reading
      |> Enum.frequencies()
      |> Map.to_list()
      |> List.keysort(1)

    %{least_common_bit: least_common_bit, most_common_bit: most_common_bit}
  end
end
