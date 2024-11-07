defmodule Day06 do
  @moduledoc """
  Dia 06 do Advent of Code de 2015
  """

  def run() do
    input =
      File.read!("input.txt")
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_instruction/1)

    {time, result} = :timer.tc(&part01/1, [input])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result}" <>
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

  # - Problema 01
  def part01(instructions) do
    instructions
    |> Enum.reduce(MapSet.new(), fn instruction, acc ->
      execute_instruction(instruction, acc)
    end)
    |> MapSet.size()
  end

  def execute_instruction({command, {x0, y0}, {x1, y1}}, lights) do
    updated_lights =
      for x <- x0..x1, y <- y0..y1, do: {x, y}

    case command do
      "turn on" -> turn_on(lights, updated_lights)
      "turn off" -> turn_off(lights, updated_lights)
      "toggle" -> toggle(lights, updated_lights)
    end
  end

  def turn_on(lights, updated_lights) do
    MapSet.union(
      lights,
      updated_lights |> MapSet.new()
    )
  end

  def turn_off(lights, updated_lights) do
    MapSet.difference(
      lights,
      updated_lights |> MapSet.new()
    )
  end

  def toggle(lights, []), do: lights

  def toggle(lights, [current_light | remaining_lights]) do
    if MapSet.member?(lights, current_light) do
      toggle(
        MapSet.delete(lights, current_light),
        remaining_lights
      )
    else
      toggle(
        MapSet.put(lights, current_light),
        remaining_lights
      )
    end
  end
end

# ---- Run

Day06.run
