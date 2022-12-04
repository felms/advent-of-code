defmodule Day04 do
  @moduledoc """
  Dia 04 do Advent of Code 2022
  """

  # ======= Problema 01 - Contar as tarefas onde as seções estão inclusas uma na outra
  def fully_overlapping_assignments do

    File.read!("./input.txt")
    |> String.replace("\r", "") # Para evitar problemas no Windows
    |> String.split("\n", trim: true)
    |> Enum.map(fn pair -> 
      String.split(pair, ",", trim: true) 
      |> Enum.map(fn item -> create_range(item) end)
    end)
    |> Enum.map(fn [range0, range1] -> 
      r0 = MapSet.new(range0);
      r1 = MapSet.new(range1);

      cond do 
        MapSet.subset?(r0, r1) or MapSet.subset?(r1, r0) -> 1
        true -> 0
      end
    end)
    |> Enum.sum

  end

  # ======= Problema 02 - Contar as tarefas onde as seções se sobrepõem
  def overlapping_assignments do

    File.read!("./input.txt")
    |> String.replace("\r", "") # Para evitar problemas no Windows
    |> String.split("\n", trim: true)
    |> Enum.map(fn pair -> 
      String.split(pair, ",", trim: true) 
      |> Enum.map(fn item -> create_range(item) end)
    end)
    |> Enum.map(fn [range0, range1] -> 
      cond do 
        MapSet.disjoint?(MapSet.new(range0), MapSet.new(range1)) -> 0
        true -> 1
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

end

# ---- Run
IO.puts("Part 01")
Day04.fully_overlapping_assignments |> IO.puts

IO.puts("\nPart 02")
Day04.overlapping_assignments |> IO.puts

