defmodule Day01 do
  @moduledoc """
  Dia 01 do Advent Of Code de 2021
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
    |> Enum.map(&String.to_integer/1)
  end

  # ======= Problema 01
  defp part_01([first_reading | _] = input) do
    measure_depth_increases(input, first_reading, 0)
  end

  # ======= Problema 02
  defp part_02(input) do
    input
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> measure_depth_increases(1_000_000_000_000, 0)
  end

  # ======= Utilitários
  defp measure_depth_increases([], _previous_depth, number_of_increases), do: number_of_increases

  defp measure_depth_increases([current_depth | depths], previous_depth, number_of_increases)
       when current_depth > previous_depth,
       do: measure_depth_increases(depths, current_depth, number_of_increases + 1)

  defp measure_depth_increases([current_depth | depths], _previous_depth, number_of_increases),
    do: measure_depth_increases(depths, current_depth, number_of_increases)
end

# ---- Run
System.argv
|> hd
|> Day01.run
