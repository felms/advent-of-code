defmodule Day03 do
  @moduledoc """
  Dia 03 do Advent of Code de 2021
  """

 
  def run(input_file) do
    input = parse_input(input_file)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "==Part 02== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  defp parse_input(file) do
    File.read!(file)
    # Para evitar problemas no Windows
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  # ===== PART 01
  defp part_01(input) do
    input
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> gamma_epsilon_rate(%{gamma_bits: [], epsilon_bits: []})
    |> Enum.map(fn {_k, v} -> v |> Enum.join() |> String.to_integer(2) end)
    |> Enum.product()
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

  # ===== PART 02
  defp part_02(input) do
    oxygen_generator_rating(input) * co2_scrubber_rating(input)
  end

  defp oxygen_generator_rating(readings) do
    filter_data(readings, 0, :oxygen_generator)
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp co2_scrubber_rating(readings) do
    filter_data(readings, 0, :co2_scrubber)
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp filter_data(readings, _position, _equipment) when length(readings) == 1,
    do: readings |> List.first()

  defp filter_data(readings, position, equipment) do
    criteria =
      readings
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.at(position)
      |> criteria_bit(equipment)

    filtered_readings =
      readings
      |> Enum.filter(fn item -> Enum.at(item, position) == criteria end)

    filter_data(filtered_readings, position + 1, equipment)
  end

  defp criteria_bit(reading, :co2_scrubber), do: criteria_bit_csr(reading)
  defp criteria_bit(reading, :oxygen_generator), do: criteria_bit_ogr(reading)

  defp criteria_bit_ogr(reading) do
    bits_freq = most_and_least_common_bit(reading)

    if bits_freq.most_common_bit == bits_freq.least_common_bit do
      1
    else
      bits_freq.most_common_bit
    end
  end

  defp criteria_bit_csr(reading) do
    bits_freq = most_and_least_common_bit(reading)

    if bits_freq.most_common_bit == bits_freq.least_common_bit do
      0
    else
      bits_freq.least_common_bit
    end
  end
end

# ---- Run
System.argv
|> hd
|> Day03.run