defmodule RangeMapping do
  defstruct [:source_r_start, :dest_r_start, :range_length]

  def is_number_in_range(range, number) do
    number >= range.source_r_start and number <= range.source_r_start + (range.range_length - 1)
  end

  def get_mapping(range, number) do
    range.dest_r_start + (number - range.source_r_start)
  end
end
