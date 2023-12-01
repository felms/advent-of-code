defmodule Day01 do
  @moduledoc """
  Dia 04 do Advent of Code 2022
  """

  def run(mode \\ :real_input) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)

    part_01(input)
  end

  # - Resolve a parte 01 do problema
  def part_01(input) do
    input
    |> Enum.map(&get_calibration_value/1)
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
end
