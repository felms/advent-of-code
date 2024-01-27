defmodule Day10 do
  @moduledoc """
  Dia 10 do Advent of Code de 2015
  """

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

    # {time, result} = :timer.tc(&part02/1, [input])

    # IO.puts(
    #   "\n==Part 02== \n\nResult: #{result}" <>
    #     "\nCalculated in #{time / 1_000_000} seconds\n"
    # )
  end

  # - Problema 01
  def part01(input) do
    execute_steps(input |> String.trim() |> String.to_integer(), 40)
    |> Integer.to_string()
    |> String.length()
  end

  # - Problema 02
  def part02(input) do
    execute_steps(input |> String.trim() |> String.to_integer(), 50)
    |> Integer.to_string()
    |> String.length()
  end

  def execute_steps(input, number_of_steps) do
    1..number_of_steps
    |> Enum.reduce(input, fn _, acc ->
      step(acc)
    end)
  end

  def step(input) do
    step(input |> Integer.digits(), [])
    |> compress([])
  end

  def step([], digits), do: digits
  def step([head | tail], []), do: step(tail, [{head, 1}])

  def step([head | tail], digits) do
    step(tail, combine_to_head(digits, head))
  end

  def combine_to_head([head | tail] = list, digit) do
    {number, count} = head

    cond do
      number == digit -> [{number, count + 1} | tail]
      true -> [{digit, 1} | list]
    end
  end

  def compress([], number), do: number |> Integer.undigits()

  def compress([{digit, count} | tail], number) do
    compress(tail, [count, digit | number])
  end
end
