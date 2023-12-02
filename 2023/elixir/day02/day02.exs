defmodule Day02 do
  @moduledoc """
  Dia 02 do Advent of Code 2023
  """

  # the bag contains only 12 red cubes, 13 green cubes, and 14 blue cubes
  @max_cubes %{red: 12, green: 13, blue: 14}

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

  # Problema 01
  def part_01(input) do
    input
    |> Enum.map(fn game -> if is_possible(game), do: game.id, else: 0 end)
    |> Enum.sum()
  end

  # Problema 02
  def part_02(input) do
    input
    |> Enum.map(&minimum_necessary_cubes/1)
    |> Enum.map(&power_of_set/1)
    |> Enum.sum()
  end

  # ======= Utilitários

  # - Retorna a potência de um conjunto de cubos
  def power_of_set(cubes) do
    cubes.red * cubes.green * cubes.blue
  end

  # - Retorno o número mínimo de cubos necessários 
  # para um jogo ser possível
  def minimum_necessary_cubes(game) do
    %{
      red: game.handfuls |> Enum.map(fn handful -> handful.red end) |> Enum.max(),
      green: game.handfuls |> Enum.map(fn handful -> handful.green end) |> Enum.max(),
      blue: game.handfuls |> Enum.map(fn handful -> handful.blue end) |> Enum.max()
    }
  end

  # - Testa se um jogo é possível
  def is_possible(game) do
    ok_red =
      game.handfuls
      |> Enum.map(fn handful -> handful.red end)
      |> Enum.all?(fn red_cubes -> red_cubes <= @max_cubes.red end)

    ok_green =
      game.handfuls
      |> Enum.map(fn handful -> handful.green end)
      |> Enum.all?(fn green_cubes -> green_cubes <= @max_cubes.green end)

    ok_blue =
      game.handfuls
      |> Enum.map(fn handful -> handful.blue end)
      |> Enum.all?(fn blue_cubes -> blue_cubes <= @max_cubes.blue end)

    ok_red and ok_green and ok_blue
  end

  # - Faz o parse do input
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_game/1)
  end

  # - Faz o parse de um "jogo" 
  def parse_game(input) do
    [id_number, _] = String.split(input, ":")

    %{
      id: id_number |> String.replace("Game ", "") |> String.to_integer(),
      handfuls: input |> String.split(";") |> Enum.map(&parse_handful/1)
    }
  end

  # - Faz o parse de cada "mãozada" de cubos
  def parse_handful(input) do
    red_cubes = parse_cube("red", input)
    green_cubes = parse_cube("green", input)
    blue_cubes = parse_cube("blue", input)

    %{red: red_cubes, green: green_cubes, blue: blue_cubes}
  end

  # - Procura na string o valor relativo à cor indicada
  def parse_cube(cube_color, input_string) do
    case Regex.run(~r/(\d+) #{cube_color}/, input_string, capture: :all_but_first) do
      nil -> 0
      [x] -> String.to_integer(x)
    end
  end
end

# ---- Run
System.argv
|> hd
|> Day02.run