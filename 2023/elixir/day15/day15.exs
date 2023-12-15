defmodule Day15 do
  @moduledoc """
  Dia 15 do Advent of Code 2023
  """

  Code.require_file("box.ex")

  def run(input_file) do

    input = File.read!(input_file)

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

  # - Problema 01
  def part_01(input) do
    input
    |> String.replace("\n", "")
    |> String.split(",", trim: true)
    |> Enum.map(&get_hash/1)
    |> Enum.sum()
  end

  def part_02(input) do
    input
    |> process_input()
    |> get_total_focusing_power()
  end

  # - Gera o códido HASH de uma string
  def get_hash(input_string) do
    input_string
    |> String.graphemes()
    |> Enum.reduce(0, fn letter, current_value ->
      (current_value + get_ascii_code(letter))
      |> then(&(&1 * 17))
      |> then(&rem(&1, 256))
    end)
  end

  # - Recupera o códico ASCII de uma letra
  def get_ascii_code(letter), do: letter |> String.to_charlist() |> hd

  # - Processa a sequencia de passos especificada no input e gera um
  # nov HASHMAP
  def process_input(input_string) do
    hashmap =
      0..255
      |> Enum.reduce(%{}, fn box_number, acc ->
        Map.put(acc, box_number, Box.new(box_number))
      end)

    input_string
    |> String.replace("\n", "")
    |> String.split(",", trim: true)
    |> Enum.reduce(hashmap, fn instruction, acc -> execute_instruction(instruction, acc) end)
  end

  # - Calcula a potencia focal total da
  # configuração de lentes
  def get_total_focusing_power(hashmap) do
    hashmap
    |> Enum.map(fn {_k, v} -> Box.get_focusing_power(v) end)
    |> Enum.sum()
  end

  # - Processa um passo específico da sequencia
  # e executa a instrução
  def execute_instruction(instruction, hashmap) do
    [_, operation] =  Regex.run(~r/.+(\=|\-)\d*/, instruction)
    case operation do
      "=" -> execute_put(instruction, hashmap)
      "-" -> execute_delete(instruction, hashmap)
    end
  end

  # - Coloca ou substitui um item no hashmap
  def execute_put(instruction, hashmap) do
    [lens_label, focal_length] = String.split(instruction, "=", trim: true)

    hash_code = lens_label |> get_hash()
    box = hashmap[hash_code]

    lens_index = box.lenses |> Enum.find_index(fn {label, _v} -> label == lens_label end)

    if lens_index do
      lenses =
        box.lenses
        |> List.replace_at(lens_index, {lens_label, focal_length |> String.to_integer()})

      Map.put(hashmap, hash_code, Box.new(hash_code, lenses))
    else
      lenses = [{lens_label, focal_length |> String.to_integer()} | box.lenses]
      Map.put(hashmap, hash_code, Box.new(hash_code, lenses))
    end
  end

  # - Exclui um item do hashmap
  def execute_delete(instruction, hashmap) do
    lens_label = instruction |> String.replace("-", "")

    hash_code = lens_label |> get_hash()

    box = hashmap[hash_code]

    lens_index = box.lenses |> Enum.find_index(fn {label, _v} -> label == lens_label end)

    if lens_index do
      lenses = List.delete_at(box.lenses, lens_index)
      Map.put(hashmap, hash_code, Box.new(hash_code, lenses))
    else
      hashmap
    end
  end
end

# ---- Run
System.argv
|> hd
|> Day15.run