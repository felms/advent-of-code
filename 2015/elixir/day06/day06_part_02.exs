defmodule Day06Part02 do
  @moduledoc """
  Parte 02 do dia 06 do Advent of Code de 2015
  """

  def run() do
    input =
      File.read!("input.txt")
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_instruction/1)

    {time, result} = :timer.tc(&part02/1, [input])

    IO.puts(
      "\n==Part 02== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  def parse_instruction(instruction) do
    [_, command, x0, y0, x1, y1] =
      Regex.run(~r/(.+)\s+(\d+),(\d+) through (\d+),(\d+)/, instruction)

    {
      command,
      {x0 |> String.to_integer(), y0 |> String.to_integer()},
      {x1 |> String.to_integer(), y1 |> String.to_integer()}
    }
  end

  # - Problema 02
  def part02(instructions) do
    instructions
    |> Enum.reduce(%{}, fn instruction, acc ->
      execute_instruction(instruction, acc)
    end)
    |> Enum.reduce(0, fn {_, brightness}, acc -> acc + brightness end)
  end

  def execute_instruction({command, {x0, y0}, {x1, y1}}, lights) do
    updated_lights =
      for x <- x0..x1, y <- y0..y1, do: {x, y}

    execute_instruction(command, updated_lights, lights)
  end

  def execute_instruction(_, [], lights), do: lights

  def execute_instruction(command, [current_light | remaining_lights], lights) do
    value = Map.get(lights, current_light, 0)

    new_value =
      case command do
        "turn on" -> value + 1
        "turn off" -> if value == 0, do: 0, else: value - 1
        "toggle" -> value + 2
      end

    execute_instruction(command, remaining_lights, Map.put(lights, current_light, new_value))
  end
end

# ---- Run

Day06Part02.run
