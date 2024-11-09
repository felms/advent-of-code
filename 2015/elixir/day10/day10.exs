defmodule Day10 do
  @moduledoc """
  Dia 10 do Advent of Code de 2015
  """

  @regex ~r/(\d)\1*/

  def run() do
    input_file = "input.txt"

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")

    {time, result} = :timer.tc(&part01/1, [input])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part02/1, [input])

    IO.puts(
      "\n==Part 02== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  # - Problema 01
  def part01(input) do
    execute_steps(input |> String.trim(), 40)
    |> String.length()
  end

  # - Problema 02
  def part02(input) do
    execute_steps(input |> String.trim(), 50)
    |> String.length()
  end

  def execute_steps(input, number_of_steps) do
    1..number_of_steps
    |> Enum.reduce(input, fn _, acc ->
      step(acc)
    end)
  end

  def step(input) do
    Regex.scan(@regex, input)
    |> Enum.map(fn [digits, number] -> 
       (digits |> String.length() |> Integer.to_string()) <> number
    end)
    |> Enum.join()
  end
end

# ---- Run

Day10.run
