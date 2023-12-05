defmodule Day05 do
  @moduledoc """
  Dia 05 do Advent of Code 2023
  """

  Code.require_file("conversion_map.ex")

  def run(input_file) do

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> parse_input()

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

  def part_01({seeds_list, conversion_maps}) do
    [first_map] = conversion_maps |> Enum.filter(&(&1.from == "seed"))

    seeds_list
    |> Enum.map(fn seed -> map_to_location(seed, first_map, conversion_maps) end)
    |> Enum.min()
  end

  def part_02({seeds_list, conversion_maps}) do
    [first_map] = conversion_maps |> Enum.filter(&(&1.from == "seed"))

    seeds_list
    |> Enum.chunk_every(2)
    |> Enum.map(fn [start_of_range, length] ->
      start_of_range..(start_of_range + length - 1)
      |> Enum.reduce(1_000_000_000_000_000_000, fn current_seed, acc ->
        min(
          acc,
          map_to_location(current_seed, first_map, conversion_maps)
        )
      end)
    end)
    |> Enum.min()
  end

  def parse_input(input_data) do
    [seed_input | mappings_input] = input_data |> String.split("\n\n", trim: true)

    seeds_list =
      seed_input
      |> String.replace("seeds: ", "")
      |> String.split(~r/\s+/, trim: true)
      |> Enum.map(&String.to_integer/1)

    conversion_maps =
      mappings_input
      |> Enum.map(&ConversionMap.new/1)

    {seeds_list, conversion_maps}
  end

  def map_to_location(current_number, current_map, conversion_maps) do
    if current_map.to == "location" do
      ConversionMap.convert(current_map, current_number)
    else
      new_current_number = ConversionMap.convert(current_map, current_number)

      [new_current_map] = conversion_maps |> Enum.filter(&(&1.from == current_map.to))
      map_to_location(new_current_number, new_current_map, conversion_maps)
    end
  end
end

# ---- Run
System.argv
|> hd
|> Day05.run