defmodule Day05 do
  @moduledoc """
  Dia 05 do Advent of Code 2022
  """

  # ======= Problema 01 - Mover as caixas e encontrar o estado final
  def organize_stacks do

    input = File.read!("./input.txt")
    |> String.replace("\r", "") # Para evitar problemas no Windows

    [number_of_crates] = Regex.run(~r/\b[\s\d]+\b/, input)
    crate_labels = number_of_crates |> String.trim |> String.split

    # Map que será usado para amazenar as listas de caixas
    map_of_crates = Enum.reduce(crate_labels, %{}, fn label, acc ->
      Map.put(acc, String.to_integer(label), [])
    end)

    # Separo o estado inicial da lista dos movimentos
    [crates, moves] = String.split(input, number_of_crates, trim: true)

    # Faço o 'parse' do estado inicial
    parsed_crates = crates
                    |> String.split("\n", trim: true)
                    |> Enum.map(fn line ->
                      String.graphemes(line)
                      |> Enum.chunk_every(4)
                      |> Enum.map(fn chunk -> Enum.join(chunk) end)
                    end)
                    |> Enum.reverse
                    |> tl 
                    |> Enum.reduce(map_of_crates, fn item, acc -> 
                      fill_lists(acc, item) 

                    end)

    # Pego a lista dos movimentos
    moves_list = String.split(moves, "\n", trim: true)

    # Aplico o(s) movimento
    resulting_state = Enum.reduce(moves_list, parsed_crates, fn moveString, acc -> 

      [[quantity], [from], [to]] = Regex.scan(~r/\d+/, moveString)
      parsed_move = [String.to_integer(quantity), String.to_integer(from), String.to_integer(to)]
      apply_move(acc, parsed_move)
    end)

    # Pego o resultado e exibo
    resulting_state
    |> Enum.map(fn {_key, value} -> 
      [head | _] = value
      head |> String.trim |> String.replace(~r/\[|\]/, "")
    end)
    |> Enum.join("")

  end

  # ======= Problema 02 - Mover várias caixas em um só movimento
  def updated_organize_stacks do

    input = File.read!("./input.txt")
    |> String.replace("\r", "") # Para evitar problemas no Windows

    [number_of_crates] = Regex.run(~r/\b[\s\d]+\b/, input)
    crate_labels = number_of_crates |> String.trim |> String.split

    # Map que será usado para amazenar as listas de caixas
    map_of_crates = Enum.reduce(crate_labels, %{}, fn label, acc ->
      Map.put(acc, String.to_integer(label), [])
    end)

    # Separo o estado inicial da lista dos movimentos
    [crates, moves] = String.split(input, number_of_crates, trim: true)

    # Faço o 'parse' do estado inicial
    parsed_crates = crates
                    |> String.split("\n", trim: true)
                    |> Enum.map(fn line ->
                      String.graphemes(line)
                      |> Enum.chunk_every(4)
                      |> Enum.map(fn chunk -> Enum.join(chunk) end)
                    end)
                    |> Enum.reverse
                    |> tl 
                    |> Enum.reduce(map_of_crates, fn item, acc -> 
                      fill_lists(acc, item) 

                    end)

    # Pego a lista dos movimentos
    moves_list = String.split(moves, "\n", trim: true)


    # Aplico o(s) movimento
    resulting_state = Enum.reduce(moves_list, parsed_crates, fn moveString, acc -> 

      [[quantity], [from], [to]] = Regex.scan(~r/\d+/, moveString)
      parsed_move = [String.to_integer(quantity), String.to_integer(from), String.to_integer(to)]
      apply_moves(acc, parsed_move)
    end)

    # Pego o resultado e exibo
    resulting_state
    |> Enum.map(fn {_key, value} -> 
      [head | _] = value
      head |> String.trim |> String.replace(~r/\[|\]/, "")
    end)
    |> Enum.join("")

  end

  # ======= Utilitários

  # - Preenche as listas do mapa com os dados de uma 
  # das listas de entrada
  defp fill_lists(map_of_lists, list) do

    list
    |> Enum.with_index()
    |> Enum.reduce(map_of_lists, fn {element, index}, acc ->

      cond do
        String.trim(element) |> String.length > 0 -> 
          list = [element | Map.get(map_of_lists, index + 1)]
          Map.put(acc, index + 1, list)
        true -> acc
      end

    end)
  end

  # - Aplica um movimento as listas
  defp apply_move(map_of_lists, move) do

    [quantity, from, to] = move

    cond do
      quantity === 0 -> map_of_lists
      true ->
        [from_head | from_tail] = Map.get(map_of_lists, from)
        to_list = [from_head | Map.get(map_of_lists, to)]
        new_map = Map.put(map_of_lists, from, from_tail) |> Map.put(to, to_list)
        apply_move(new_map, [quantity - 1, from, to])
    end

  end

  # - Aplica varios movimento de uma só vez
  defp apply_moves(map_of_lists, move) do

    [quantity, from, to] = move

    from_list = Map.get(map_of_lists, from)
    from_length = length(from_list)
    from_head = Enum.take(from_list, quantity)
    from_tail = Enum.take(from_list, quantity - from_length) 

    to_list = from_head ++ Map.get(map_of_lists, to)

    Map.put(map_of_lists, from, from_tail) |> Map.put(to, to_list)
    
  end
end

# ---- Run
IO.puts("Part 01")
Day05.organize_stacks |> IO.puts

IO.puts("\nPart 02")
Day05.updated_organize_stacks |> IO.puts


