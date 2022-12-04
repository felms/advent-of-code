defmodule Day04 do
  @moduledoc """
  Dia 04 do Advent of Code 2022
  """

  # ======= Problema 01 - Contar as tarefas onde as seções se sobrepõem
  def overlapping_assignments do

    File.read!("./input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn pair -> 
      String.split(pair, ",", trim: true) 
      |> Enum.map(fn item -> create_range(item) end)
    end)
    |> Enum.map(fn assignment -> 
      cond do 
        one_range_contains_other?(assignment) -> 1
        true -> 0
      end
      end)
      |> Enum.sum
  end

  
  # ======= Utilitários

  # - Cria um 'range' com os limites dados
  defp create_range(item) do
    [from, to] = String.split(item, "-", trim: true) 
                 |> Enum.map(fn number -> String.to_integer(number) end)
    Enum.to_list(from..to)
  end

  # - Testa se os 'ranges' estão contidos um no outro
  defp one_range_contains_other?([range0, range1]) do

    r0 = MapSet.new(range0);
    r1 = MapSet.new(range1);

    MapSet.subset?(r0, r1) or MapSet.subset?(r1, r0)

  end

end
