defmodule Day14 do
  @moduledoc """
  Dia 14 do Advent of Code 2022
  """

  def parse_input(input_file) do
    File.read!(input_file)
    |> String.replace("\r", "") # Para evitar problemas no Windows
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(MapSet.new(), fn points, acc -> 
      parse_points(points, acc)
    end)
  end

  # - Transfoma uma linha de texto em lista de pontos
  def parse_line(line) do
    line
    |> String.split(" -> ", trim: true)
    |> Enum.map(fn point -> 
      [x, y] = String.split(point, ",", trim: true)
      {String.to_integer(x), String.to_integer(y)}
    end)
  end

  # - Gera um estrutura de rocha da caverna
  # com base em uma lista de pontos
  def parse_points(_, [], structure), do: structure

  def parse_points(start_of_segment, points, structure) do
    [end_of_segment | remaining_points] = points

    updated_structure = create_segment(start_of_segment, end_of_segment)
                        |> Enum.reduce(structure, fn point, acc -> 
                          MapSet.put(acc, point)
                        end)

    parse_points(end_of_segment, remaining_points, updated_structure)
  end

  def parse_points(points, structure) do
    [first_point|remaining_points] = points
    parse_points(first_point, remaining_points, structure)
  end

  # - Gera os pontos que criam um segmento 
  # entre 'start' e 'end'
  def create_segment(start_pont, end_point) do
    {x0, y0} = start_pont
    {x1, y1} = end_point

    for x <- x0..x1, y <- y0..y1, do: {x, y}
  end
  
end
