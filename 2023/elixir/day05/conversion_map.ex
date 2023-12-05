defmodule ConversionMap do

  Code.require_file("range_mapping.ex")

  defstruct [:from, :to, :range_mappings]

  def new(input) do
    [header | ranges] = input |> String.split("\n", trim: true)

    [_, from, to] = Regex.run(~r/(.+)-to-(.+)\s+map:/, header)

    mappings =
      Enum.reduce(ranges, [], fn range, acc ->
        acc ++ [parse_range_mapping(range)]
      end)

    %ConversionMap{from: from, to: to, range_mappings: mappings}
  end

  def parse_range_mapping(range_mapping) do
    [dest_range_start, source_range_start, range_length] =
      range_mapping |> String.split(~r/\s+/, trim: true) |> Enum.map(&String.to_integer/1)

    %RangeMapping{
      source_r_start: source_range_start,
      dest_r_start: dest_range_start,
      range_length: range_length
    }
  end

  def convert(conversion_map, number) do
    range =
      conversion_map.range_mappings
      |> Enum.filter(fn range -> RangeMapping.is_number_in_range(range, number) end)

    case range do
      [] -> number
      [x] -> RangeMapping.get_mapping(x, number)
    end
  end
end
