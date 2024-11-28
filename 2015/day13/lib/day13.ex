defmodule Day13 do
  @moduledoc """
  Dia 13 do Advent of Code de 2015
  """
  def run(file_name \\ "sample_input.txt") do
    input_file = file_name

    input =
      File.read!(input_file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> parse_input

    # {time, result} = :timer.tc(&part01/1, [input])

    # IO.puts(
    #   "\n==Part 01== \n\nResult: #{result}" <>
    #     "\nCalculated in #{time / 1_000_000} seconds\n"
    # )

    # {time, result} = :timer.tc(&part02/1, [input])

    # IO.puts(
    #   "\n==Part 02== \n\nResult: #{result}" <>
    #     "\nCalculated in #{time / 1_000_000} seconds\n"
    # )
  end

  def parse_input(input) do
    lines =
      input
      |> String.split("\n")
      |> Enum.map(&parse_line/1)

    %{
      people: lines |> Enum.map(&(&1.name)) |> Enum.uniq(),
      happiness_potential: lines
    }
  end

  def parse_line(line) do
    Regex.named_captures(
      ~r/(?<name>.+) would (?<gain_or_loss>.+) (?<qtde>.+) happiness units by sitting next to (?<neighbor>.+)./,
      line
    )
    |> process_line
  end

  def process_line(line_captures) do
    multiplier = if line_captures["gain_or_loss"] == "lose", do: -1, else: 1

    %{
      name: line_captures["name"],
      neighbor: line_captures["neighbor"],
      qtde: multiplier * (line_captures["qtde"] |> String.to_integer())
    }
  end

  # - Problema 01
  # def part01(input) do
  #   Regex.scan(~r/-?\d+/, input)
  #   |> Enum.map(fn [x] -> String.to_integer(x) end)
  #   |> Enum.sum
  # end
end
