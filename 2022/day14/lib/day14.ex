defmodule Day14 do
  @moduledoc """
  Dia 14 do Advent of Code 2022
  """

  # ======= Problema 01 - Número de grãos até
  # que eles comecem a cair no 'endless void'
  def part_01(input_file) do
    grid = parse_input(input_file)

    # - Valor máximo de y. Se algum grão chegar 
    # a esse ponto, sabemos que ele foi para o 'endless void'
    max_y = Enum.map(grid, fn {{_x, y}, _v} -> y end)
            |> Enum.max

    # - Loop que derruba grãos até que um caia fora do grid
    {grains, _} = Enum.reduce_while(0..(max_y * max_y), {0, grid}, fn _, acc -> 
      {number_of_grains, current_grid} = acc

      {new_grid, {_, curr_y}} = Cave.drop_sand(current_grid)
      
      if curr_y === max_y do
        {:halt, {number_of_grains, new_grid}}
      else
        {:cont, {number_of_grains + 1, new_grid}}
      end
      
    end)

    grains

  end

  # - Faz o parse do input e gera as estruturas iniciais
  def parse_input(input_file) do

    # Gera as estruturas iniciais
    structures = File.read!(input_file)
                 |> String.replace("\r", "") # Para evitar problemas no Windows
                 |> String.split("\n", trim: true)
                 |> Enum.map(&parse_line/1)
                 |> Enum.reduce(MapSet.new(), fn points, acc -> 
                   parse_points(points, acc)
                 end)

    # Descobre os valores minimos e máximos de x e y
    {min_x, _min_y, max_x, max_y} = 
      MapSet.to_list(structures)
      |> Enum.reduce({100000, 100000, 0, 0}, fn {x, y}, acc -> 
        {min_ax, min_ay, max_ax, max_ay} = acc
        {min(min_ax, x), min(min_ay, y), max(max_ax, x), max(max_ay, y)}
      end)

    # Gera todos os pontos possíveis
    all_points = for x <- (min_x - 5)..(max_x + 5),
      y <- 0..(max_y + 5), do: {x, y}

    # Cria o grid com os pontos
    grid = Enum.reduce(all_points, %{}, fn point, acc -> 
      Map.put(acc, point, ".")
    end)

    # Insere as estrutura no grid
    MapSet.to_list(structures)
    |> Enum.reduce(grid, fn point, acc -> Map.put(acc, point, "#") end)

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
