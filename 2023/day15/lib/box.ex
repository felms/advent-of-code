defmodule Box do
  defstruct [:box_number, lenses: []]

  def new(number) do
    %Box{box_number: number}
  end

  def new(number, lenses) do
    %Box{box_number: number, lenses: lenses}
  end

  # - Calcula a potencia focal total de uma caixa
  def get_focusing_power(box) do
    box_number = box.box_number + 1

    box.lenses
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {lens, index} -> lens_focusing_power(lens, box_number, index) end)
    |> Enum.sum()
  end

  # - Calcula a potencia focal de uma lente
  defp lens_focusing_power({_lens_label, focal_length}, box_number, slot) do
    box_number * slot * focal_length
  end
end
