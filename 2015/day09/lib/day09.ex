defmodule Day09 do
  @moduledoc """
  Dia 09 do Advent of Code de 2015
  """

  def run(mode \\ :real_input) do
    input_file = if mode == :sample, do: "sample_input.txt", else: "input.txt"

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> parse_input()

  end

  # - Problema 01
  def part01(input) do
    # TODO
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce([], fn distance, acc ->
      [_, from, to, dist] = Regex.run(~r/(.+) to (.+) = (\d+)/, distance)
      [{{from, to}, String.to_integer(dist)} | acc]
    end)
  end

  def min_dists(curr_city, dists, total_dist) do
    # TODO 
  end
end
