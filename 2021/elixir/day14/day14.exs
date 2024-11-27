defmodule Day14 do
  @moduledoc """
  Dia 14 do Advent of Code de 2021
  """

  @number_of_steps 10

  def run(input_file) do
    input = parse_input(input_file)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult:\n#{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    # {time, result} = :timer.tc(&part_02/1, [input])

    # IO.puts(
    #   "==Part 02== \nResult: \n\n#{result}" <>
    #     "\n\nCalculated in #{time / 1_000_000} seconds\n"
    # )
  end

  defp parse_input(file) do
    [template, rules] =
      File.read!(file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.split("\n\n", trim: true)

    {template, parse_rules(rules)}
  end

  defp parse_rules(rules) do
    rules
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_rule/1)
    |> Map.new()
  end

  defp parse_rule(rule) do
    [pair, element] = String.split(rule, " -> ", trim: true)
    [element_0, element_1] = String.graphemes(pair)
    {pair, element_0 <> element <> element_1}
  end

  # ======= Problema 01
  defp part_01({template, rules}) do
    {min, max} =
      execute_steps(template, rules, @number_of_steps)
      |> String.graphemes()
      |> Enum.frequencies()
      |> Enum.map(fn {_k, v} -> v end)
      |> Enum.min_max()

    max - min
  end

  # ======= Problema 02
  # defp part_02({points, folds}) do
  # end

  # ======= Utilitários

  defp execute_steps(template, rules, steps), do: execute_steps(template, rules, steps, 0)
  defp execute_steps(template, _rules, x, x), do: template

  defp execute_steps(template, rules, steps, current_step) do
    execute_step({template, rules}) |> execute_steps(rules, steps, current_step + 1)
  end

  defp execute_step({template, rules}) do
    template
    |> String.graphemes()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(fn pair -> rules[pair] end)
    |> merge()
  end

  defp merge(list), do: merge(list, "")
  defp merge([], acc), do: acc
  defp merge([first_string | remaining_strings], ""), do: merge(remaining_strings, first_string)

  defp merge([first_string | remaining_strings], acc) do
    slice_end = String.length(acc) - 2
    merge(remaining_strings, String.slice(acc, 0..slice_end) <> first_string)
  end
end

# ---- Run
System.argv
|> hd
|> Day14.run
