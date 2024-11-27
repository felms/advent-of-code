defmodule Day14V2 do
  @moduledoc """
  Dia 14 do Advent of Code de 2021
  """
  Code.require_file("state.exs")

  @number_of_steps_p1 10
  @number_of_steps_p2 40

  def run(input_file) do
    input = parse_input(input_file)

    {time, result} = :timer.tc(&part_01/1, [input])

    IO.puts(
      "==Part 01== \nResult:\n#{result}" <>
        "\nCalculated in #{time / 1_000_000} seconds\n"
    )

    {time, result} = :timer.tc(&part_02/1, [input])

    IO.puts(
      "==Part 02== \nResult: \n\n#{result}" <>
        "\n\nCalculated in #{time / 1_000_000} seconds\n"
    )
  end

  defp parse_input(file) do
    [template, rules] =
      File.read!(file)
      # Para evitar problemas no Windows
      |> String.replace("\r", "")
      |> String.split("\n\n", trim: true)

    State.init(template, rules)
  end

  # ======= Problema 01
  defp part_01(state) do
    {min, max} =
      execute_steps(state, @number_of_steps_p1, 0)
      |> Map.fetch!(:letter_freq)
      |> Enum.map(fn {_k, v} -> v end)
      |> Enum.min_max()

    max - min
  end

  # ======= Problema 02
  defp part_02(state) do
    {min, max} =
      execute_steps(state, @number_of_steps_p2, 0)
      |> Map.fetch!(:letter_freq)
      |> Enum.map(fn {_k, v} -> v end)
      |> Enum.min_max()

    max - min
  end

  # ======= Utilitários

  defp execute_steps(state, x, x), do: state

  defp execute_steps(state, number_of_steps, current_step) do
    state
    |> execute_step()
    |> execute_steps(number_of_steps, current_step + 1)
  end

  defp execute_step(state) do
    letter_freq = update_letters(state)
    pair_freq = update_pairs(state)
    %{state | letter_freq: letter_freq, pair_freq: pair_freq}
  end

  defp update_letters(state) do
    Enum.reduce(state.rules, state.letter_freq, fn {rule_pair, rule}, acc ->
      {letter, _pairs_list} = rule

      if Map.has_key?(state.pair_freq, rule_pair) do
        value_to_add = Map.get(state.pair_freq, rule_pair)
        previous_freq = Map.get(acc, letter, 0)
        Map.put(acc, letter, previous_freq + value_to_add)
      else
        acc
      end
    end)
  end

  defp update_pairs(state) do
    Enum.reduce(Map.to_list(state.rules), %{}, fn {rule_pair, rule}, acc ->
      {_letter, {first_pair, second_pair}} = rule
      value_to_add = Map.get(state.pair_freq, rule_pair, 0)

      if value_to_add > 0 do
        fp_value = Map.get(acc, first_pair, 0)
        sp_value = Map.get(acc, second_pair, 0)

        Map.put(acc, first_pair, value_to_add + fp_value)
        |> Map.put(second_pair, value_to_add + sp_value)
      else
        acc
      end
    end)
  end
end

# ---- Run
System.argv
|> hd
|> Day14V2.run
