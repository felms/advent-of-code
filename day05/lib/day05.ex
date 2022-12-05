defmodule Day05 do
  @moduledoc """
  Dia 05 do Advent of Code 2022
  """

  def read_file do

    input = File.read!("./input.txt")

    [number_of_crates] = Regex.run(~r/\b[\s\d]+\b/, input)
    crate_labels = number_of_crates |> String.trim |> String.split

    # Map que será usado para amazenar as listas de caixas
    map_of_crates = Enum.reduce(crate_labels, %{}, fn label, acc ->
      Map.put(acc, String.to_integer(label), [])
    end)

    [crates, moves] = String.split(input, number_of_crates, trim: true)
    moves_list = String.split(moves, "\n", trim: true)

    parsed_crates = crates
                    |> String.split("\n", trim: true)
                    |> Enum.map(fn line ->
                      String.graphemes(line)
                      |> Enum.chunk_every(4)
                      |> Enum.map(fn chunk -> Enum.join(chunk) end)
                    end)
                    |> Enum.reverse
                    |> tl

    # {map_of_crates, parsed_crates, crate_labels, moves_list}

    # [list | _ ] = parsed_crates
    # fill_lists(map_of_crates, list)

    map_of_lists = parsed_crates
    |> Enum.reduce(map_of_crates, fn item, acc -> 
      fill_lists(acc, item) 

    end)


    {map_of_lists, moves_list}

  end


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

end
