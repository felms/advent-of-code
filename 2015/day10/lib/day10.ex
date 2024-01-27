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
  end

  # - Problema 01
  def part01(input) do
      execute_steps(input |> String.trim() |> String.to_integer(), 40) 
      |> Integer.to_string() |> String.length()
  end

  def execute_steps(input, number_of_steps) do
    1..number_of_steps
    |> Enum.reduce(input, fn _, acc ->
      step(acc)
    end)
  end

  # - Base case
  def step(1), do: 11
  # - Remaining cases
  def step(input) do
    [digit | digits] = input |> Integer.digits()
    step(digits, digit, []) |> Integer.undigits()
  end

  def step([head_digit | rem_digits], current_digit, []),
    do: step(rem_digits, head_digit, [{current_digit, 1}])

  def step([], current_digit, [h_counts | t_counts]) do
    {digit, count} = h_counts

    res_digits =
      cond do
        digit == current_digit -> [{digit, count + 1} | t_counts]
        true -> [{current_digit, 1}, h_counts | t_counts]
      end

    res_digits |> Enum.reverse() |> collapse([])
  end

  def step([head_digit | tail_digits], current_digit, [h_counts | t_counts]) do
    {digit, count} = h_counts

    cond do
      digit == current_digit -> step(tail_digits, head_digit, [{digit, count + 1} | t_counts])
      true -> step(tail_digits, head_digit, [{current_digit, 1}, h_counts | t_counts])
    end
  end

  def collapse([], number), do: number

  def collapse([h | tail], number) do
    {num, cnt} = h
    collapse(tail, number ++ [cnt, num])
  end
end
