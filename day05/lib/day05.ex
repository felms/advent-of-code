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
   _moves_list = String.split(moves, "\n", trim: true)

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


#    fill_lists(map_of_crates, list)
#    map_of_crates

    Enum.each(parsed_crates, fn item -> fill_lists(map_of_crates, item) end)

    map_of_crates

  end


  defp fill_lists(map_of_lists, list) do

    list
    |> Enum.with_index()
    |> Enum.map(fn {element, index} ->

      list = [element | Map.get(map_of_lists, index + 1)]
      Map.replace(map_of_lists, index + 1, list)

    end)
  end

end
