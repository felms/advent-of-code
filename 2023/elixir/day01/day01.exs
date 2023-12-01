defmodule Day01 do
  @moduledoc """
  Dia 01 do Advent of Code 2023
  """

  def run(input_file) do

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)

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

  # - Resolve a parte 01 do problema
  def part_01(input) do
    input
    |> Enum.map(&get_calibration_value/1)
    |> Enum.sum()
  end

  # - Resolve a parte 02 do problema
  def part_02(input) do
    input
    |> Enum.map(&get_calibration_value_part_02/1)
    |> Enum.sum()
  end

  # - Gera o número do valor de calibração
  # com base na string de input
  def get_calibration_value(input_string) do
    digits =
      input_string
      |> String.graphemes()
      |> Enum.reject(fn letter -> letter =~ ~r/[a-zA-Z]/ end)

    (List.first(digits) <> List.last(digits))
    |> String.to_integer()
  end

  # - Gera o número do valor de calibração
  # com base na string de input também utilizando os
  # digitos escritos.
  def get_calibration_value_part_02(input_string) do
    # Feio, mas foi uma maneira simples de se livrar
    # dos "edge cases". Por exemplo: "sevenine", "eighthree", etc...
    string_to_number = %{
      "one" => "one1one",
      "two" => "two2two",
      "three" => "three3three",
      "four" => "four4four",
      "five" => "five5five",
      "six" => "six6six",
      "seven" => "seven7seven",
      "eight" => "eight8eight",
      "nine" => "nine9nine"
    }

    string_to_number
    |> Map.keys()
    |> Enum.reduce(input_string, fn mapping, acc ->
      String.replace(acc, mapping, Map.get(string_to_number, mapping))
    end)
    |> get_calibration_value()
  end
end

# ---- Run
System.argv
|> hd
|> Day01.run
