defmodule Day02 do
  @moduledoc """
  Dia 02 do Advent of Code de 2021
  """

  @initial_state %{horizontal_position: 0, depth: 0}

  # Roda o problema no modo correto (teste ou real)
  def run(:sample), do: solve("sample_input.txt")
  def run(:real), do: solve("input.txt")

  # Chama o método para a solução do problema
  defp solve(input_file) do
    input = parse_input(input_file)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult: #{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    # {time, result} = :timer.tc(&part_02/1, [input])

    # IO.puts(
    #   "==Part 02== \nResult: #{result}" <>
    #     "\nCalculated in #{time / 1_000_000} seconds\n"
    # )
  end

  defp part_01(input) do
    res = exec_commands(@initial_state, input)
    res.horizontal_position * res.depth
  end

  defp parse_input(file) do
    File.read!(file)
    # Para evitar problemas no Windows
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_command/1)
  end

  defp parse_command(command_str) do
    [command, units] = String.split(command_str, " ", trim: true)
    {command, String.to_integer(units)}
  end

  defp exec_command(submarine, {command, units}) do
    case command do
      "forward" -> %{submarine | horizontal_position: submarine.horizontal_position + units}
      "down" -> %{submarine | depth: submarine.depth + units}
      "up" -> %{submarine | depth: submarine.depth - units}
    end
  end

  defp exec_commands(submarine, []), do: submarine

  defp exec_commands(submarine, [command | rest]),
    do: submarine |> exec_command(command) |> exec_commands(rest)
end
