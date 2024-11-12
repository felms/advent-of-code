defmodule Day02 do
  @moduledoc """
  Dia 02 do Advent of Code de 2021
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

  # ======= Problema 01
  defp part_01(input) do
    res = exec_commands(%{horizontal_position: 0, depth: 0}, input, :part_01)
    res.horizontal_position * res.depth
  end

  # ======= Problema 02
  defp part_02(input) do
    res = exec_commands(%{horizontal_position: 0, depth: 0, aim: 0}, input, :part_02)
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

  # ======= Utilitários
  defp exec_command(submarine, {command, units}) do
    case command do
      "forward" -> %{submarine | horizontal_position: submarine.horizontal_position + units}
      "down" -> %{submarine | depth: submarine.depth + units}
      "up" -> %{submarine | depth: submarine.depth - units}
    end
  end

  defp exec_command_02(submarine, {command, units}) do
    case command do
      "forward" ->
        %{
          submarine
          | horizontal_position: submarine.horizontal_position + units,
            depth: submarine.depth + submarine.aim * units
        }

      "down" ->
        %{submarine | aim: submarine.aim + units}

      "up" ->
        %{submarine | aim: submarine.aim - units}
    end
  end

  defp exec_commands(submarine, [], _), do: submarine

  defp exec_commands(submarine, [command | rest], :part_01),
    do: submarine |> exec_command(command) |> exec_commands(rest, :part_01)

  defp exec_commands(submarine, [command | rest], :part_02),
    do: submarine |> exec_command_02(command) |> exec_commands(rest, :part_02)
end

# ---- Run
System.argv
|> hd
|> Day02.run