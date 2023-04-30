defmodule State do
  defstruct rules: %{}, pair_freq: %{}, letter_freq: %{}

  def init(template, rules_string) do
    rules = parse_rules(rules_string)

    letter_freq =
      template
      |> String.graphemes()
      |> Enum.frequencies()

    pair_freq =
      template
      |> String.graphemes()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&Enum.join/1)
      |> Enum.frequencies()

    %State{rules: rules, letter_freq: letter_freq, pair_freq: pair_freq}
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
    {pair, {element, {element_0 <> element, element <> element_1}}}
  end
end
