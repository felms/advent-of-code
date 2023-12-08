defmodule Day08 do
  @moduledoc """
  Dia 08 do Advent of Code 2023
  """

  def run() do
    input =
      File.read!("input.txt")
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> parse_input()

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "\n==Part 01== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "\n==Part 02== \n\nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  def part_01({instructions, grid}), do: execute_steps(instructions, grid, "AAA", 0)

  def part_02({instructions, grid}) do
    grid
    |> Map.keys()
    |> Enum.filter(&(String.at(&1, -1) == "A"))
    |> Enum.map(&execute_steps_02(instructions, grid, &1, 0))
    |> Enum.reduce(1, fn current_number, acc -> lcm(acc, current_number) end)
  end

  def execute_steps_02(instructions, grid, current_location, step) do
    if current_location |> String.at(-1) == "Z" do
      step
    else
      pos = rem(step, instructions |> String.length())

      instruction = instructions |> String.at(pos)

      case instruction do
        "L" -> execute_steps_02(instructions, grid, grid[current_location].left, step + 1)
        "R" -> execute_steps_02(instructions, grid, grid[current_location].right, step + 1)
      end
    end
  end

  def execute_steps(_instructions, _grid, "ZZZ", step), do: step

  def execute_steps(instructions, grid, current_location, step) do
    pos = rem(step, instructions |> String.length())

    instruction = instructions |> String.at(pos)

    case instruction do
      "L" -> execute_steps(instructions, grid, grid[current_location].left, step + 1)
      "R" -> execute_steps(instructions, grid, grid[current_location].right, step + 1)
    end
  end

  def parse_input(input_string) do
    [instructions, nodes_list] = input_string |> String.split("\n\n", trim: true)

    grid =
      nodes_list
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_node/1)
      |> Map.new()

    {instructions, grid}
  end

  def parse_node(input_string) do
    [_, node, left, right] = Regex.run(~r/(.+) = \((.+), (.+)\)/, input_string)

    {node, %{left: left, right: right}}
  end

  def lcm(a, b), do: a * div(b, gcd(a, b))

  def gcd(a, b) do
    if b == 0, do: a, else: gcd(b, rem(a, b))
  end
end

# ---- Run
Day08.run