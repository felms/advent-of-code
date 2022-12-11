defmodule Day11 do
  @moduledoc """
  Dia 11 do Advent of Code 2022
  """

  Code.require_file("monkeys.exs")
  

  # ======= Problema 01 - Nivel de 'monkey business'
  # depois de 20 rodadas
  def part_01 do

    # Faz o parse do input e gera a estrutura de dados inicial
    monkeys = File.read!("./input.txt")
	|> String.replace("\r", "") # Para evitar problemas no Windows
    |> String.split("\n\n")
    |> Enum.map(fn line -> Monkeys.parse_monkey(line) end)
    |> Enum.reduce(%{}, fn monkey, acc ->
      {id, map} = monkey
      Map.put(acc, id, map)
    end)

    Enum.reduce(0..19, monkeys, fn _round, acc ->
      execute_round(acc)
    end)
    |> Enum.map(fn {_, monkey} -> monkey.inspected_items end)
    |> Enum.sort(:desc) |> Enum.take(2) |> Enum.product

  end

  # ======= Problema 02 - Nivel de 'monkey business'
  # depois de 10000 rodadas e sem alivio
  def part_02 do

    # Faz o parse do input e gera a estrutura de dados inicial
    monkeys = File.read!("./input.txt")
	|> String.replace("\r", "") # Para evitar problemas no Windows
    |> String.split("\n\n")
    |> Enum.map(fn line -> Monkeys.parse_monkey(line) end)
    |> Enum.reduce(%{}, fn monkey, acc ->
      {id, map} = monkey
      Map.put(acc, id, map)
    end)

    Enum.reduce(0..9999, monkeys, fn _round, acc ->
      execute_round_without_relief(acc)
    end)
    |> Enum.map(fn {_, monkey} -> monkey.inspected_items end)
    |> Enum.sort(:desc) |> Enum.take(2) |> Enum.product

  end

  # - Executa uma rodada para todos os macacos
  def execute_round(monkeys) do

    number_of_monkeys = monkeys |> Enum.count
    number_of_monkeys = number_of_monkeys - 1

    Enum.reduce(0..number_of_monkeys, monkeys, fn monkey_id, acc ->
      Monkeys.execute_round(acc, monkey_id)
    end)

  end

 # - Executa uma rodada para todos os macacos
 def execute_round_without_relief(monkeys) do

    number_of_monkeys = monkeys |> Enum.count
    number_of_monkeys = number_of_monkeys - 1

    Enum.reduce(0..number_of_monkeys, monkeys, fn monkey_id, acc ->
      Monkeys.execute_round_without_relief(acc, monkey_id)
    end)

  end

 end

# --- Run
IO.puts("Part 01")
Day11.part_01
|> IO.puts

IO.puts("\nPart 02")
Day11.part_02
|> IO.puts