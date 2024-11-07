defmodule Day07 do
  @moduledoc """
  Dia 07 do Advent of Code de 2015
  """

  def run() do
	
    input =
      File.read!("input.txt")
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.split("\n", trim: true)

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
    input
    |> execute_instructions(%{})
    |> Enum.filter(fn {k, _v} -> k == "a" end)
    |> hd()
    |> then(fn {_k, v} -> v end)
  end

  # - Problema 02
  def part02(input) do
    a_value = part01(input)

    input
    |> Enum.reject(&String.match?(&1, ~r/(\d+)\s+->\s+b$/))
    |> execute_instructions(%{"b" => a_value})
    |> Enum.filter(fn {k, _v} -> k == "a" end)
    |> hd()
    |> then(fn {_k, v} -> v end)
  end

  def execute_instructions([], circuit), do: circuit

  def execute_instructions([current_instrucion | remaining_instrucions], circuit) do
    {status, new_circuit} = execute_instruction(current_instrucion, circuit)

    case status do
      :err -> execute_instructions(remaining_instrucions ++ [current_instrucion], circuit)
      :ok -> execute_instructions(remaining_instrucions, new_circuit)
    end
  end

  def execute_instruction(instruction, circuit) do
    cond do
      String.contains?(instruction, ["AND", "OR"]) -> exec_and_or(instruction, circuit)
      String.contains?(instruction, ["LSHIFT", "RSHIFT"]) -> exec_shift(instruction, circuit)
      String.contains?(instruction, "NOT") -> exec_not(instruction, circuit)
      true -> provide_signal(instruction, circuit)
    end
  end

  def exec_and_or(instruction, circuit) do
    [_, w0, oper, w1, wres] = Regex.run(~r/(.+)\s+(AND|OR)\s+(.+)\s+->\s+(.+)/, instruction)
    # [w0, oper, w1, _, wres] = instruction |> String.split(~r/\s+/, trim: true) |> IO.inspect

    wire0 = if String.match?(w0, ~r/\d+/), do: String.to_integer(w0), else: Map.get(circuit, w0)
    wire1 = if String.match?(w1, ~r/\d+/), do: String.to_integer(w1), else: Map.get(circuit, w1)

    cond do
      wire0 == nil or wire1 == nil -> {:err, circuit}
      oper == "AND" -> {:ok, Map.put(circuit, wres, Bitwise.band(wire0, wire1))}
      oper == "OR" -> {:ok, Map.put(circuit, wres, Bitwise.bor(wire0, wire1))}
    end
  end

  def exec_shift(instruction, circuit) do
    [_, w0, oper, u, wres] = Regex.run(~r/(.+)\s+(LSHIFT|RSHIFT)\s+(.+)\s+->\s+(.+)/, instruction)
    # [w0, oper, u, _, wres] = instruction |> String.split(~r/\s+/, trim: true)

    wire0 = if String.match?(w0, ~r/\d+/), do: String.to_integer(w0), else: Map.get(circuit, w0)
    units = u |> String.to_integer()

    cond do
      wire0 == nil -> {:err, circuit}
      oper == "LSHIFT" -> {:ok, Map.put(circuit, wres, Bitwise.bsl(wire0, units))}
      oper == "RSHIFT" -> {:ok, Map.put(circuit, wres, Bitwise.bsr(wire0, units))}
    end
  end

  def exec_not(instruction, circuit) do
    [_, w0, wres] = Regex.run(~r/NOT\s+(.+)\s+->\s+(.+)/, instruction)
    # [_, w0, _, wres] = instruction |> String.split(~r/\s+/, trim: true)

    wire0 = Map.get(circuit, w0)

    if wire0 == nil do
      {:err, circuit}
    else
      {:ok, Map.put(circuit, wres, 65536 + Bitwise.bnot(wire0))}
    end
  end

  def provide_signal(instruction, circuit) do
    # [_, w0, w1] = Regex.run(~r/(\d+)\s+->\s+(.+)/, instruction)
    [w0, w1] = instruction |> String.split(" -> ", trim: true)

    cond do
      String.match?(w0, ~r/\d+/) -> {:ok, Map.put(circuit, w1, String.to_integer(w0))}
      Map.has_key?(circuit, w0) -> {:ok, Map.put(circuit, w1, Map.get(circuit, w0))}
      true -> {:err, circuit}
    end
  end
end

# ---- Run

Day07.run